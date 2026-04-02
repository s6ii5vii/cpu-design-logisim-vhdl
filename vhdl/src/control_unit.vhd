library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit_VHDL is
    Port (
        opcode       : in  STD_LOGIC_VECTOR(5 downto 0);
        reset        : in  STD_LOGIC;
        reg_dst      : out STD_LOGIC_VECTOR(1 downto 0);
        mem_to_reg   : out STD_LOGIC_VECTOR(1 downto 0);
        alu_op       : out STD_LOGIC_VECTOR(1 downto 0);
        jump         : out STD_LOGIC;
        branch       : out STD_LOGIC;
        mem_read     : out STD_LOGIC;
        mem_write    : out STD_LOGIC;
        alu_src      : out STD_LOGIC;
        reg_write    : out STD_LOGIC;
        sign_or_zero : out STD_LOGIC
    );
end Control_Unit_VHDL;

architecture Behavioral of Control_Unit_VHDL is
begin
    process(opcode, reset)
    begin
        reg_dst      <= "00";
        mem_to_reg   <= "00";
        alu_op       <= "00";
        jump         <= '0';
        branch       <= '0';
        mem_read     <= '0';
        mem_write    <= '0';
        alu_src      <= '0';
        reg_write    <= '0';
        sign_or_zero <= '0';

        if reset = '1' then
            null;
        else
            case opcode is
                when "000000" => -- add (R-type)
                    reg_dst    <= "01";
                    mem_to_reg <= "00";
                    alu_op     <= "00";
                    reg_write  <= '1';

                when "001011" => -- sltiu / "sliu" in assignment wording
                    reg_dst      <= "00";
                    mem_to_reg   <= "00";
                    alu_op       <= "10";
                    alu_src      <= '1';
                    reg_write    <= '1';
                    sign_or_zero <= '1';

                when "000010" => -- j
                    jump <= '1';

                when "000011" => -- jal
                    reg_dst    <= "10";
                    mem_to_reg <= "10";
                    jump       <= '1';
                    reg_write  <= '1';

                when "100011" => -- lw
                    reg_dst    <= "00";
                    mem_to_reg <= "01";
                    alu_op     <= "11";
                    mem_read   <= '1';
                    alu_src    <= '1';
                    reg_write  <= '1';

                when "101011" => -- sw
                    alu_op    <= "11";
                    mem_write <= '1';
                    alu_src   <= '1';

                when "000100" => -- beq
                    alu_op  <= "01";
                    branch  <= '1';

                when "001000" => -- addi
                    reg_dst    <= "00";
                    mem_to_reg <= "00";
                    alu_op     <= "11";
                    alu_src    <= '1';
                    reg_write  <= '1';

                when others =>
                    null;
            end case;
        end if;
    end process;
end Behavioral;
