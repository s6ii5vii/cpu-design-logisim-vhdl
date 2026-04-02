library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Control_TB is
end ALU_Control_TB;

architecture Behavioral of ALU_Control_TB is

    component ALU_Control_VHDL
        Port (
            ALUOp       : in  STD_LOGIC_VECTOR(1 downto 0);
            ALU_Funct   : in  STD_LOGIC_VECTOR(2 downto 0);
            ALU_Control : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    signal ALUOp       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal ALU_Funct   : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal ALU_Control : STD_LOGIC_VECTOR(2 downto 0);

begin

    uut: ALU_Control_VHDL
        port map (
            ALUOp       => ALUOp,
            ALU_Funct   => ALU_Funct,
            ALU_Control => ALU_Control
        );

    stim_proc: process
    begin
        ALUOp <= "00";
        ALU_Funct <= "011";
        wait for 10 ns;
        assert ALU_Control = "011"
            report "ALUOp=00 should pass through ALU_Funct"
            severity error;

        ALUOp <= "01";
        wait for 10 ns;
        assert ALU_Control = "001"
            report "ALUOp=01 should select subtract"
            severity error;

        ALUOp <= "10";
        wait for 10 ns;
        assert ALU_Control = "100"
            report "ALUOp=10 should select set-less-than"
            severity error;

        ALUOp <= "11";
        wait for 10 ns;
        assert ALU_Control = "000"
            report "ALUOp=11 should select add"
            severity error;

        report "ALU control checks completed successfully." severity note;
        wait;
    end process;

end Behavioral;
