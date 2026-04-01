library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_VHDL is
    Port (
        a           : in  STD_LOGIC_VECTOR(15 downto 0);
        b           : in  STD_LOGIC_VECTOR(15 downto 0);
        alu_control : in  STD_LOGIC_VECTOR(2 downto 0);
        alu_result  : out STD_LOGIC_VECTOR(15 downto 0);
        zero        : out STD_LOGIC
    );
end ALU_VHDL;

architecture Behavioral of ALU_VHDL is
    signal result : STD_LOGIC_VECTOR(15 downto 0);
begin

    process(a, b, alu_control)
    begin
        case alu_control is
            when "000" => -- ADD
                result <= STD_LOGIC_VECTOR(signed(a) + signed(b));

            when "001" => -- SUB
                result <= STD_LOGIC_VECTOR(signed(a) - signed(b));

            when "010" => -- AND
                result <= a and b;

            when "011" => -- OR
                result <= a or b;

            when "100" => -- SLT
                if signed(a) < signed(b) then
                    result <= x"0001";
                else
                    result <= x"0000";
                end if;

            when others =>
                result <= x"0000";
        end case;
    end process;

    alu_result <= result;
    zero <= '1' when result = x"0000" else '0';

end Behavioral;