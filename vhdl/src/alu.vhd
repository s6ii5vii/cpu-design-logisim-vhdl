library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_VHDL is
    Port (
        a           : in  STD_LOGIC_VECTOR(31 downto 0);
        b           : in  STD_LOGIC_VECTOR(31 downto 0);
        alu_control : in  STD_LOGIC_VECTOR(2 downto 0);
        alu_result  : out STD_LOGIC_VECTOR(31 downto 0);
        zero        : out STD_LOGIC
    );
end ALU_VHDL;

architecture Behavioral of ALU_VHDL is
    signal result : STD_LOGIC_VECTOR(31 downto 0);
begin

    process(a, b, alu_control)
        variable signed_a : signed(31 downto 0);
        variable signed_b : signed(31 downto 0);
    begin
        signed_a := signed(a);
        signed_b := signed(b);

        case alu_control is
            when "000" => -- ADD
                result <= STD_LOGIC_VECTOR(signed_a + signed_b);

            when "001" => -- SUB
                result <= STD_LOGIC_VECTOR(signed_a - signed_b);

            when "010" => -- AND
                result <= a and b;

            when "011" => -- OR
                result <= a or b;

            when "100" => -- SET-ON-LESS-THAN (signed)
                if signed_a < signed_b then
                    result <= x"00000001";
                else
                    result <= x"00000000";
                end if;

            when others =>
                result <= STD_LOGIC_VECTOR(signed_a + signed_b);
        end case;
    end process;

    alu_result <= result;
    zero <= '1' when result = x"00000000" else '0';

end Behavioral;
