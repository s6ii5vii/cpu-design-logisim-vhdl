library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is

    component ALU_VHDL
        Port (
            a           : in  STD_LOGIC_VECTOR(31 downto 0);
            b           : in  STD_LOGIC_VECTOR(31 downto 0);
            alu_control : in  STD_LOGIC_VECTOR(2 downto 0);
            alu_result  : out STD_LOGIC_VECTOR(31 downto 0);
            zero        : out STD_LOGIC
        );
    end component;

    signal a           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal b           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal alu_control : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal alu_result  : STD_LOGIC_VECTOR(31 downto 0);
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
        -- ADD: 2500 + 25000
        a <= std_logic_vector(to_signed(2500, 32));
        b <= std_logic_vector(to_signed(25000, 32));
        alu_control <= "000";
        wait for 10 ns;

        -- SUB: 540250 - 37800
        a <= std_logic_vector(to_signed(540250, 32));
        b <= std_logic_vector(to_signed(37800, 32));
        alu_control <= "001";
        wait for 10 ns;

        -- AND: 53957 AND 30000
        a <= std_logic_vector(to_unsigned(53957, 32));
        b <= std_logic_vector(to_unsigned(30000, 32));
        alu_control <= "010";
        wait for 10 ns;

        -- OR: 746353 OR 846465
        a <= std_logic_vector(to_unsigned(746353, 32));
        b <= std_logic_vector(to_unsigned(846465, 32));
        alu_control <= "011";
        wait for 10 ns;

        -- SLT: 58847537 < 72464383
        a <= std_logic_vector(to_signed(58847537, 32));
        b <= std_logic_vector(to_signed(72464383, 32));
        alu_control <= "100";
        wait for 10 ns;

        wait;
    end process;

end Behavioral;