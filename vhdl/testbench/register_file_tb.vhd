library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File_TB is
end Register_File_TB;

architecture Behavioral of Register_File_TB is

    component Register_File_VHDL
        Port (
            clk             : in  STD_LOGIC;
            rst             : in  STD_LOGIC;
            reg_write_en    : in  STD_LOGIC;
            reg_write_dest  : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
            reg_read_addr_1 : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_read_addr_2 : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_read_data_1 : out STD_LOGIC_VECTOR(31 downto 0);
            reg_read_data_2 : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal clk             : STD_LOGIC := '0';
    signal rst             : STD_LOGIC := '0';
    signal reg_write_en    : STD_LOGIC := '0';
    signal reg_write_dest  : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_write_data  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal reg_read_addr_1 : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_read_addr_2 : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_read_data_1 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_read_data_2 : STD_LOGIC_VECTOR(31 downto 0);

begin

    uut: Register_File_VHDL
        port map (
            clk => clk,
            rst => rst,
            reg_write_en => reg_write_en,
            reg_write_dest => reg_write_dest,
            reg_write_data => reg_write_data,
            reg_read_addr_1 => reg_read_addr_1,
            reg_read_addr_2 => reg_read_addr_2,
            reg_read_data_1 => reg_read_data_1,
            reg_read_data_2 => reg_read_data_2
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

    stim_proc: process
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';

        reg_read_addr_1 <= "001";
        reg_read_addr_2 <= "011";
        wait for 10 ns;

        reg_write_en <= '1';
        reg_write_dest <= "010";
        reg_write_data <= x"12345678";
        wait for 10 ns;

        reg_write_en <= '0';
        reg_read_addr_1 <= "010";
        reg_read_addr_2 <= "111";
        wait for 10 ns;

        wait;
    end process;

end Behavioral;