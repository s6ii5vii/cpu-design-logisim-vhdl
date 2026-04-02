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

    procedure check_result (
        constant expected_result : in STD_LOGIC_VECTOR(31 downto 0);
        constant expected_zero   : in STD_LOGIC;
        constant label_text      : in string
    ) is
    begin
        assert alu_result = expected_result
            report label_text & " result mismatch"
            severity error;
        assert zero = expected_zero
            report label_text & " zero flag mismatch"
            severity error;
    end procedure;

begin

    uut: ALU_VHDL
        port map (
            a           => a,
            b           => b,
            alu_control => alu_control,
            alu_result  => alu_result,
            zero        => zero
        );

    stim_proc: process
    begin
        -- Task 2(i): Add 2500 to 25000
        a <= std_logic_vector(to_unsigned(2500, 32));
        b <= std_logic_vector(to_unsigned(25000, 32));
        alu_control <= "000";
        wait for 20 ns;
        check_result(std_logic_vector(to_unsigned(27500, 32)), '0', "Task 2(i)");

        -- Task 2(ii): Subtract 37800 from 540250
        a <= std_logic_vector(to_unsigned(540250, 32));
        b <= std_logic_vector(to_unsigned(37800, 32));
        alu_control <= "001";
        wait for 20 ns;
        check_result(std_logic_vector(to_unsigned(502450, 32)), '0', "Task 2(ii)");

        -- Task 2(iii): AND 53957 and 30000
        a <= std_logic_vector(to_unsigned(53957, 32));
        b <= std_logic_vector(to_unsigned(30000, 32));
        alu_control <= "010";
        wait for 20 ns;
        check_result(std_logic_vector(to_unsigned(20480, 32)), '0', "Task 2(iii)");

        -- Task 2(iv): OR 746353 and 846465
        a <= std_logic_vector(to_unsigned(746353, 32));
        b <= std_logic_vector(to_unsigned(846465, 32));
        alu_control <= "011";
        wait for 20 ns;
        check_result(std_logic_vector(to_unsigned(1043441, 32)), '0', "Task 2(iv)");

        -- Task 2(v): Compare 58847537 and 72464383
        a <= std_logic_vector(to_unsigned(58847537, 32));
        b <= std_logic_vector(to_unsigned(72464383, 32));
        alu_control <= "100";
        wait for 20 ns;
        check_result(x"00000001", '0', "Task 2(v)");

        -- Return to an ADD operation so the compare interval is clearly visible
        -- in GTKWave instead of ending exactly at the right boundary.
        a <= (others => '0');
        b <= (others => '0');
        alu_control <= "000";
        wait for 20 ns;

        report "ALU task checks completed successfully." severity note;

        wait;
    end process;

end Behavioral;
