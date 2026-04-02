library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit_TB is
end Control_Unit_TB;

architecture Behavioral of Control_Unit_TB is

    component Control_Unit_VHDL
        Port (
            opcode       : in  STD_LOGIC_VECTOR(5 downto 0);
            reset        : in  STD_LOGIC;
            reg_dst      : out STD_LOGIC_VECTOR(1 downto 0);
            mem_to_reg   : out STD_LOGIC_VECTOR(1 downto 0);
            alu_op       : out STD_LOGIC_VECTOR(1 downto 0);
            jump         : out STD_LOGIC;
            branch       : out STD_LOGIC;
            mem_read     : out STD_LOGIC;
            mem_write    : out STD_LOGIC;
            alu_src      : out STD_LOGIC;
            reg_write    : out STD_LOGIC;
            sign_or_zero : out STD_LOGIC
        );
    end component;

    signal opcode       : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal reset        : STD_LOGIC := '0';
    signal reg_dst      : STD_LOGIC_VECTOR(1 downto 0);
    signal mem_to_reg   : STD_LOGIC_VECTOR(1 downto 0);
    signal alu_op       : STD_LOGIC_VECTOR(1 downto 0);
    signal jump         : STD_LOGIC;
    signal branch       : STD_LOGIC;
    signal mem_read     : STD_LOGIC;
    signal mem_write    : STD_LOGIC;
    signal alu_src      : STD_LOGIC;
    signal reg_write    : STD_LOGIC;
    signal sign_or_zero : STD_LOGIC;

    procedure check_control (
        constant expected_reg_dst      : in STD_LOGIC_VECTOR(1 downto 0);
        constant expected_mem_to_reg   : in STD_LOGIC_VECTOR(1 downto 0);
        constant expected_alu_op       : in STD_LOGIC_VECTOR(1 downto 0);
        constant expected_jump         : in STD_LOGIC;
        constant expected_branch       : in STD_LOGIC;
        constant expected_mem_read     : in STD_LOGIC;
        constant expected_mem_write    : in STD_LOGIC;
        constant expected_alu_src      : in STD_LOGIC;
        constant expected_reg_write    : in STD_LOGIC;
        constant expected_sign_or_zero : in STD_LOGIC;
        constant label_text            : in string
    ) is
    begin
        assert reg_dst = expected_reg_dst report label_text & " reg_dst mismatch" severity error;
        assert mem_to_reg = expected_mem_to_reg report label_text & " mem_to_reg mismatch" severity error;
        assert alu_op = expected_alu_op report label_text & " alu_op mismatch" severity error;
        assert jump = expected_jump report label_text & " jump mismatch" severity error;
        assert branch = expected_branch report label_text & " branch mismatch" severity error;
        assert mem_read = expected_mem_read report label_text & " mem_read mismatch" severity error;
        assert mem_write = expected_mem_write report label_text & " mem_write mismatch" severity error;
        assert alu_src = expected_alu_src report label_text & " alu_src mismatch" severity error;
        assert reg_write = expected_reg_write report label_text & " reg_write mismatch" severity error;
        assert sign_or_zero = expected_sign_or_zero report label_text & " sign_or_zero mismatch" severity error;
    end procedure;

begin

    uut: Control_Unit_VHDL
        port map (
            opcode       => opcode,
            reset        => reset,
            reg_dst      => reg_dst,
            mem_to_reg   => mem_to_reg,
            alu_op       => alu_op,
            jump         => jump,
            branch       => branch,
            mem_read     => mem_read,
            mem_write    => mem_write,
            alu_src      => alu_src,
            reg_write    => reg_write,
            sign_or_zero => sign_or_zero
        );

    stim_proc: process
    begin
        reset <= '1';
        wait for 10 ns;
        check_control("00", "00", "00", '0', '0', '0', '0', '0', '0', '0', "reset");

        reset <= '0';

        opcode <= "000000"; -- add
        wait for 10 ns;
        check_control("01", "00", "00", '0', '0', '0', '0', '0', '1', '0', "add");

        opcode <= "001011"; -- sliu/sltiu
        wait for 10 ns;
        check_control("00", "00", "10", '0', '0', '0', '0', '1', '1', '1', "sliu");

        opcode <= "000010"; -- j
        wait for 10 ns;
        check_control("00", "00", "00", '1', '0', '0', '0', '0', '0', '0', "j");

        opcode <= "000011"; -- jal
        wait for 10 ns;
        check_control("10", "10", "00", '1', '0', '0', '0', '0', '1', '0', "jal");

        opcode <= "100011"; -- lw
        wait for 10 ns;
        check_control("00", "01", "11", '0', '0', '1', '0', '1', '1', '0', "lw");

        opcode <= "101011"; -- sw
        wait for 10 ns;
        check_control("00", "00", "11", '0', '0', '0', '1', '1', '0', '0', "sw");

        opcode <= "000100"; -- beq
        wait for 10 ns;
        check_control("00", "00", "01", '0', '1', '0', '0', '0', '0', '0', "beq");

        opcode <= "001000"; -- addi
        wait for 10 ns;
        check_control("00", "00", "11", '0', '0', '0', '0', '1', '1', '0', "addi");

        -- Move to a final opcode so the addi control outputs remain visible
        -- as a full waveform interval rather than ending at the right edge.
        opcode <= "111111";
        wait for 10 ns;

        report "Control unit checks completed successfully." severity note;
        wait;
    end process;

end Behavioral;
