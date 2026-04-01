library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is

    component ALU_VHDL
        Port (
            a           : in  STD_LOGIC_VECTOR(15 downto 0);
            b           : in  STD_LOGIC_VECTOR(15 downto 0);
            alu_control : in  STD_LOGIC_VECTOR(2 downto 0);
            alu_result  : out STD_LOGIC_VECTOR(15 downto 0);
            zero        : out STD_LOGIC
        );
    end component;

    signal a           : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal b           : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal alu_control : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal alu_result  : STD_LOGIC_VECTOR(15 downto 0);
    signal zero        : STD_LOGIC;

begin

    uut: ALU_VHDL
        port map (
            a => a,
            b => b,
            alu_control => alu_control,
            alu_result => alu_result,
            zero => zero
        );

    stim_proc: process
    begin
        -- ADD: 5 + 3 = 8
        a <= x"0005";
        b <= x"0003";
        alu_control <= "000";
        wait for 10 ns;

        -- SUB: 5 - 3 = 2
        alu_control <= "001";
        wait for 10 ns;

        -- AND: 5 AND 3 = 1
        alu_control <= "010";
        wait for 10 ns;

        -- OR: 5 OR 3 = 7
        alu_control <= "011";
        wait for 10 ns;

        -- SLT: 3 < 5 => 1
        a <= x"0003";
        b <= x"0005";
        alu_control <= "100";
        wait for 10 ns;

        -- ZERO CHECK: 4 - 4 = 0
        a <= x"0004";
        b <= x"0004";
        alu_control <= "001";
        wait for 10 ns;

        wait;
    end process;

end Behavioral;