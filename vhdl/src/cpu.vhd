library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;

        -- Debug outputs
        pc_out          : out STD_LOGIC_VECTOR(31 downto 0);
        instruction_out : out STD_LOGIC_VECTOR(31 downto 0);
        alu_result_out  : out STD_LOGIC_VECTOR(31 downto 0);
        read_data_1_out : out STD_LOGIC_VECTOR(31 downto 0);
        read_data_2_out : out STD_LOGIC_VECTOR(31 downto 0);
        write_back_out  : out STD_LOGIC_VECTOR(31 downto 0);
        opcode_out      : out STD_LOGIC_VECTOR(5 downto 0);
        write_reg_out   : out STD_LOGIC_VECTOR(2 downto 0);
        zero_out        : out STD_LOGIC;
        reg_write_out   : out STD_LOGIC;
        mem_write_out   : out STD_LOGIC;
        mem_read_out    : out STD_LOGIC;
        alu_src_out     : out STD_LOGIC;
        mem_to_reg_out  : out STD_LOGIC;
        reg_dst_out     : out STD_LOGIC
    );
end CPU;

architecture Behavioral of CPU is

    function map_mips_reg(reg_addr : STD_LOGIC_VECTOR(4 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case reg_addr is
            when "01000" => return "001"; -- $t0 -> local register 1
            when "01001" => return "011"; -- $t1 -> local register 3
            when "01010" => return "101"; -- $t2 -> local register 5
            when "01011" => return "111"; -- $t3 -> local register 7
            when others  => return reg_addr(2 downto 0);
        end case;
    end function;

    component Instruction_Memory
        Port (
            address     : in  STD_LOGIC_VECTOR(31 downto 0);
            instruction : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component Register_File_VHDL
        Port (
            clk             : in  STD_LOGIC;
            rst             : in  STD_LOGIC;
            reg_write_en    : in  STD_LOGIC;
            reg_write_dest  : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
            reg_read_addr_1 : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_read_addr_2 : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_read_data_1 : out STD_LOGIC_VECTOR(31 downto 0);
            reg_read_data_2 : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component ALU_VHDL
        Port (
            a           : in  STD_LOGIC_VECTOR(31 downto 0);
            b           : in  STD_LOGIC_VECTOR(31 downto 0);
            alu_control : in  STD_LOGIC_VECTOR(2 downto 0);
            alu_result  : out STD_LOGIC_VECTOR(31 downto 0);
            zero        : out STD_LOGIC
        );
    end component;

    component Data_Memory
        Port (
            clk        : in  STD_LOGIC;
            mem_write  : in  STD_LOGIC;
            mem_read   : in  STD_LOGIC;
            address    : in  STD_LOGIC_VECTOR(31 downto 0);
            write_data : in  STD_LOGIC_VECTOR(31 downto 0);
            read_data  : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal pc              : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal instruction     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal opcode          : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal rs              : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal rt              : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal rd              : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal funct           : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal immediate       : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    signal read_data_1     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal read_data_2     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal sign_ext_imm    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal alu_in_b        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal alu_result      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal zero            : STD_LOGIC := '0';

    signal mem_read_data   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal write_back_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal reg_write_en    : STD_LOGIC := '0';
    signal mem_write       : STD_LOGIC := '0';
    signal mem_read        : STD_LOGIC := '0';
    signal mem_to_reg      : STD_LOGIC := '0';
    signal alu_src         : STD_LOGIC := '0';
    signal reg_dst         : STD_LOGIC := '0';
    signal alu_control     : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal write_reg       : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');

begin

    -- =========================
    -- PROGRAM COUNTER
    -- =========================
    process(clk, rst)
    begin
        if rst = '1' then
            pc <= (others => '0');
        elsif rising_edge(clk) then
            if instruction = x"00000000" then
                pc <= pc;
            else
                pc <= STD_LOGIC_VECTOR(unsigned(pc) + 2);
            end if;
        end if;
    end process;

    -- =========================
    -- FETCH
    -- =========================
    IMEM: Instruction_Memory
        port map (
            address     => pc,
            instruction => instruction
        );

    -- =========================
    -- DECODE
    -- =========================
    opcode    <= instruction(31 downto 26);
    rs        <= instruction(25 downto 21);
    rt        <= instruction(20 downto 16);
    rd        <= instruction(15 downto 11);
    funct     <= instruction(5 downto 0);
    immediate <= instruction(15 downto 0);

    sign_ext_imm <= STD_LOGIC_VECTOR(resize(signed(immediate), 32));

    -- =========================
    -- SIMPLE CONTROL UNIT
    -- =========================
    process(opcode, funct)
    begin
        reg_write_en <= '0';
        mem_write    <= '0';
        mem_read     <= '0';
        mem_to_reg   <= '0';
        alu_src      <= '0';
        reg_dst      <= '0';
        alu_control  <= "000";

        case opcode is
            when "000000" =>   -- R-type
                reg_write_en <= '1';
                reg_dst      <= '1';
                alu_src      <= '0';

                case funct is
                    when "100000" => alu_control <= "000"; -- ADD
                    when "100010" => alu_control <= "001"; -- SUB
                    when "100100" => alu_control <= "010"; -- AND
                    when "100101" => alu_control <= "011"; -- OR
                    when "101010" => alu_control <= "100"; -- SLT
                    when others   => alu_control <= "000";
                end case;

            when "100011" =>   -- LW
                reg_write_en <= '1';
                mem_read     <= '1';
                mem_to_reg   <= '1';
                alu_src      <= '1';
                reg_dst      <= '0';
                alu_control  <= "000";

            when "101011" =>   -- SW
                mem_write    <= '1';
                alu_src      <= '1';
                alu_control  <= "000";

            when "001000" =>   -- ADDI
                reg_write_en <= '1';
                alu_src      <= '1';
                reg_dst      <= '0';
                alu_control  <= "000";

            when others =>
                null;
        end case;
    end process;

    -- =========================
    -- REGISTER FILE
    -- =========================
    write_reg <= map_mips_reg(rd) when reg_dst = '1' else map_mips_reg(rt);

    REGFILE: Register_File_VHDL
        port map (
            clk             => clk,
            rst             => rst,
            reg_write_en    => reg_write_en,
            reg_write_dest  => write_reg,
            reg_write_data  => write_back_data,
            reg_read_addr_1 => map_mips_reg(rs),
            reg_read_addr_2 => map_mips_reg(rt),
            reg_read_data_1 => read_data_1,
            reg_read_data_2 => read_data_2
        );

    -- =========================
    -- EXECUTE
    -- =========================
    alu_in_b <= sign_ext_imm when alu_src = '1' else read_data_2;

    ALU: ALU_VHDL
        port map (
            a           => read_data_1,
            b           => alu_in_b,
            alu_control => alu_control,
            alu_result  => alu_result,
            zero        => zero
        );

    -- =========================
    -- MEMORY ACCESS
    -- =========================
    DMEM: Data_Memory
        port map (
            clk        => clk,
            mem_write  => mem_write,
            mem_read   => mem_read,
            address    => alu_result,
            write_data => read_data_2,
            read_data  => mem_read_data
        );

    -- =========================
    -- WRITE BACK
    -- =========================
    write_back_data <= mem_read_data when mem_to_reg = '1' else alu_result;

    -- =========================
    -- DEBUG OUTPUTS
    -- =========================
    pc_out          <= pc;
    instruction_out <= instruction;
    alu_result_out  <= alu_result;
    read_data_1_out <= read_data_1;
    read_data_2_out <= read_data_2;
    write_back_out  <= write_back_data;
    opcode_out      <= opcode;
    write_reg_out   <= write_reg;
    zero_out        <= zero;
    reg_write_out   <= reg_write_en;
    mem_write_out   <= mem_write;
    mem_read_out    <= mem_read;
    alu_src_out     <= alu_src;
    mem_to_reg_out  <= mem_to_reg;
    reg_dst_out     <= reg_dst;

end Behavioral;
