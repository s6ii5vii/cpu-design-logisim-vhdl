library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Control_VHDL is
    Port (
        ALUOp       : in  STD_LOGIC_VECTOR(1 downto 0);
        ALU_Funct   : in  STD_LOGIC_VECTOR(2 downto 0);
        ALU_Control : out STD_LOGIC_VECTOR(2 downto 0)
    );
end ALU_Control_VHDL;

architecture Behavioral of ALU_Control_VHDL is
begin
    process(ALUOp, ALU_Funct)
    begin
        case ALUOp is
            when "00" =>
                ALU_Control <= ALU_Funct;
            when "01" =>
                ALU_Control <= "001";
            when "10" =>
                ALU_Control <= "100";
            when "11" =>
                ALU_Control <= "000";
            when others =>
                ALU_Control <= "000";
        end case;
    end process;
end Behavioral;
