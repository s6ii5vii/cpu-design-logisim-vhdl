library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Memory is
    Port (
        address     : in  STD_LOGIC_VECTOR(31 downto 0);
        instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

    type memory_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);

    signal mem : memory_array := (
        0 => x"00650820", -- add $t0, $t1, $t2 using registers 1,3,5,7 as $t0..$t3
        2 => x"00A72822", -- sub $t2, $t2, $t3
        4 => x"00A11824", -- and $t1, $t2, $t0
        6 => x"00E32825", -- or  $t2, $t3, $t1
        others => (others => '0')
    );

begin

    process(address, mem)
    begin
        if unsigned(address) > to_unsigned(16#20#, 32) then
            instruction <= (others => '0');
        else
            instruction <= mem(to_integer(unsigned(address(4 downto 0))));
        end if;
    end process;

end Behavioral;
