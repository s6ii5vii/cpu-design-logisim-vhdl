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
    signal rst             : STD_LOGIC := '1';
    signal reg_write_en    : STD_LOGIC := '0';
    signal reg_write_dest  : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_write_data  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal reg_read_addr_1 : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_read_addr_2 : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_read_data_1 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_read_data_2 : STD_LOGIC_VECTOR(31 downto 0);

begin

    UUT: Register_File_VHDL
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

    clk_process: process
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
        wait for 10 ns;
        rst <= '0';
        wait for 1 ns;

        reg_read_addr_1 <= "001";
        reg_read_addr_2 <= "011";
        wait for 5 ns;
        assert reg_read_data_1 = x"00000002" and reg_read_data_2 = x"00000004"
            report "Reset values for registers 1 and 3 are incorrect"
            severity error;

        -- Task 3(i): write the required values.
        reg_write_en <= '1';
        reg_write_dest <= "001";
        reg_write_data <= std_logic_vector(to_unsigned(1934858, 32));
        wait for 10 ns;

        reg_write_en <= '1';
        reg_write_dest <= "011";
        reg_write_data <= std_logic_vector(to_unsigned(8558447, 32));
        wait for 10 ns;

        reg_write_en <= '1';
        reg_write_dest <= "101";
        reg_write_data <= std_logic_vector(to_unsigned(203848544, 32));
        wait for 10 ns;

        reg_write_en <= '1';
        reg_write_dest <= "111";
        reg_write_data <= std_logic_vector(to_unsigned(20670420, 32));
        wait for 10 ns;

        reg_write_en <= '0';

        -- Task 3(ii): read the values back.
        reg_read_addr_1 <= "001";
        reg_read_addr_2 <= "011";
        wait for 10 ns;
        assert reg_read_data_1 = std_logic_vector(to_unsigned(1934858, 32))
            report "Register 1 readback mismatch"
            severity error;
        assert reg_read_data_2 = std_logic_vector(to_unsigned(8558447, 32))
            report "Register 3 readback mismatch"
            severity error;

        reg_read_addr_1 <= "101";
        reg_read_addr_2 <= "111";
        wait for 10 ns;
        assert reg_read_data_1 = std_logic_vector(to_unsigned(203848544, 32))
            report "Register 5 readback mismatch"
            severity error;
        assert reg_read_data_2 = std_logic_vector(to_unsigned(20670420, 32))
            report "Register 7 readback mismatch"
            severity error;

        reg_read_addr_1 <= "000";
        wait for 10 ns;
        assert reg_read_data_1 = x"00000000"
            report "Register 0 should read as zero"
            severity error;

        report "Register file checks completed successfully." severity note;

        wait;
    end process;

end Behavioral;
