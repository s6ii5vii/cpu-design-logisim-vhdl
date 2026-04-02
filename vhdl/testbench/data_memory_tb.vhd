library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory_TB is
end Data_Memory_TB;

architecture Behavioral of Data_Memory_TB is

    component Data_Memory
        Port (
            clk        : in  STD_LOGIC;
            mem_write  : in  STD_LOGIC;
            mem_read   : in  STD_LOGIC;
            address    : in  STD_LOGIC_VECTOR(31 downto 0);
            write_data : in  STD_LOGIC_VECTOR(31 downto 0);
            read_data  : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal clk        : STD_LOGIC := '0';
    signal mem_write  : STD_LOGIC := '0';
    signal mem_read   : STD_LOGIC := '0';
    signal address    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal write_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal read_data  : STD_LOGIC_VECTOR(31 downto 0);

begin

    uut: Data_Memory
        port map (
            clk        => clk,
            mem_write  => mem_write,
            mem_read   => mem_read,
            address    => address,
            write_data => write_data,
            read_data  => read_data
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_proc : process
    begin
        -- Task 1(i): Write 1024 into Memory Address 2, then read it
        address    <= x"00000002";
        write_data <= std_logic_vector(to_unsigned(1024, 32));
        mem_write  <= '1';
        mem_read   <= '0';
        wait for 10 ns;

        mem_write  <= '0';
        mem_read   <= '1';
        wait for 10 ns;
        assert read_data = std_logic_vector(to_unsigned(1024, 32))
            report "Task 1(i) readback mismatch at address 2"
            severity error;

        -- Task 1(ii): Write 429496 into Memory Address 4, then read it
        address    <= x"00000004";
        write_data <= std_logic_vector(to_unsigned(429496, 32));
        mem_write  <= '1';
        mem_read   <= '0';
        wait for 10 ns;

        mem_write  <= '0';
        mem_read   <= '1';
        wait for 10 ns;
        assert read_data = std_logic_vector(to_unsigned(429496, 32))
            report "Task 1(ii) readback mismatch at address 4"
            severity error;

        report "Data memory task checks completed successfully." severity note;

        wait;
    end process;

end Behavioral;
