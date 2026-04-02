library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Memory_TB is
end Instruction_Memory_TB;

architecture Behavioral of Instruction_Memory_TB is

    signal address     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal instruction : STD_LOGIC_VECTOR(31 downto 0);

begin

    uut: entity work.Instruction_Memory
        port map (
            address     => address,
            instruction => instruction
        );

    stim_proc: process
    begin
        -- Instruction 0
        address <= x"00000000";
        wait for 20 ns;
        assert instruction = x"012A4020"
            report "Instruction 0 mismatch"
            severity error;

        -- Instruction 2
        address <= x"00000002";
        wait for 20 ns;
        assert instruction = x"014B5022"
            report "Instruction 2 mismatch"
            severity error;

        -- Instruction 4
        address <= x"00000004";
        wait for 20 ns;
        assert instruction = x"01484824"
            report "Instruction 4 mismatch"
            severity error;

        -- Instruction 6
        address <= x"00000006";
        wait for 20 ns;
        assert instruction = x"01695025"
            report "Instruction 6 mismatch"
            severity error;

        -- Move to a final empty location so the address-6 instruction is
        -- visible as its own interval instead of ending on the waveform edge.
        address <= x"00000008";
        wait for 20 ns;

        report "Instruction memory checks completed successfully." severity note;

        wait;
    end process;

end Behavioral;
