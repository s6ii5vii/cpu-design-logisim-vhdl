library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File_VHDL is
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
end Register_File_VHDL;

architecture Behavioral of Register_File_VHDL is
    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    signal regs : reg_array := (
        0 => x"00000001",
        1 => x"00000002",
        2 => x"00000003",
        3 => x"00000004",
        4 => x"00000005",
        5 => x"00000006",
        6 => x"00000007",
        7 => x"00000008"
    );
begin

    process(clk, rst)
    begin
        if rst = '1' then
            regs <= (
                0 => x"00000001",
                1 => x"00000002",
                2 => x"00000003",
                3 => x"00000004",
                4 => x"00000005",
                5 => x"00000006",
                6 => x"00000007",
                7 => x"00000008"
            );
        elsif rising_edge(clk) then
            if reg_write_en = '1' and reg_write_dest /= "000" then
                regs(to_integer(unsigned(reg_write_dest))) <= reg_write_data;
            end if;
        end if;
    end process;

    reg_read_data_1 <= regs(to_integer(unsigned(reg_read_addr_1))) when reg_read_addr_1 /= "000" else x"00000000";
    reg_read_data_2 <= regs(to_integer(unsigned(reg_read_addr_2))) when reg_read_addr_2 /= "000" else x"00000000";

end Behavioral;
