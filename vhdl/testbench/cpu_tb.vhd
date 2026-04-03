library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU_TB is
end CPU_TB;

architecture Behavioral of CPU_TB is

    component CPU
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
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
    end component;

    signal clk             : STD_LOGIC := '0';
    signal rst             : STD_LOGIC := '1';
    signal pc_out          : STD_LOGIC_VECTOR(31 downto 0);
    signal instruction_out : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_result_out  : STD_LOGIC_VECTOR(31 downto 0);
    signal read_data_1_out : STD_LOGIC_VECTOR(31 downto 0);
    signal read_data_2_out : STD_LOGIC_VECTOR(31 downto 0);
    signal write_back_out  : STD_LOGIC_VECTOR(31 downto 0);
    signal opcode_out      : STD_LOGIC_VECTOR(5 downto 0);
    signal write_reg_out   : STD_LOGIC_VECTOR(2 downto 0);
    signal zero_out        : STD_LOGIC;
    signal reg_write_out   : STD_LOGIC;
    signal mem_write_out   : STD_LOGIC;
    signal mem_read_out    : STD_LOGIC;
    signal alu_src_out     : STD_LOGIC;
    signal mem_to_reg_out  : STD_LOGIC;
    signal reg_dst_out     : STD_LOGIC;

    procedure check_cycle (
        constant expected_pc          : in STD_LOGIC_VECTOR(31 downto 0);
        constant expected_instruction : in STD_LOGIC_VECTOR(31 downto 0);
        constant expected_alu_result  : in STD_LOGIC_VECTOR(31 downto 0);
        constant label_text           : in string
    ) is
    begin
        assert pc_out = expected_pc
            report label_text & " PC mismatch"
            severity error;
        assert instruction_out = expected_instruction
            report label_text & " instruction mismatch"
            severity error;
        assert alu_result_out = expected_alu_result
            report label_text & " ALU result mismatch"
            severity error;
    end procedure;

begin

    uut: CPU
        port map (
            clk             => clk,
            rst             => rst,
            pc_out          => pc_out,
            instruction_out => instruction_out,
            alu_result_out  => alu_result_out,
            read_data_1_out => read_data_1_out,
            read_data_2_out => read_data_2_out,
            write_back_out  => write_back_out,
            opcode_out      => opcode_out,
            write_reg_out   => write_reg_out,
            zero_out        => zero_out,
            reg_write_out   => reg_write_out,
            mem_write_out   => mem_write_out,
            mem_read_out    => mem_read_out,
            alu_src_out     => alu_src_out,
            mem_to_reg_out  => mem_to_reg_out,
            reg_dst_out     => reg_dst_out
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_proc: process
    begin
        wait for 20 ns;
        rst <= '0';

        wait for 1 ns;
        check_cycle(x"00000000", x"00650820", x"0000000A", "Cycle 0");

        wait until rising_edge(clk);
        wait for 1 ns;
        check_cycle(x"00000002", x"00A72822", x"FFFFFFFE", "Cycle 1");

        wait until rising_edge(clk);
        wait for 1 ns;
        check_cycle(x"00000004", x"00A11824", x"0000000A", "Cycle 2");

        wait until rising_edge(clk);
        wait for 1 ns;
        check_cycle(x"00000006", x"00E32825", x"0000000A", "Cycle 3");

        wait until rising_edge(clk);
        wait for 1 ns;
        check_cycle(x"00000008", x"00000000", x"00000000", "Cycle 4");

        report "CPU integration checks completed successfully." severity note;

        wait;
    end process;

end Behavioral;
