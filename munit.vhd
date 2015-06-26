LIBRARY	ieee;
USE		ieee.std_logic_1164.all;
USE		ieee.numeric_std.all;

entity munit is
	port(
		CLK, RESET								: in  STD_LOGIC;
		PC, ALUOUT, WRITEDATA				: in  STD_LOGIC_VECTOR(31 downto 0);
		IORD, MEMREAD, MEMWRITE, IRWRITE	: in  STD_LOGIC;
		INSTRUCTION, MEMORYDATA				: out STD_LOGIC_VECTOR(31 downto 0)
	);
end entity;

architecture munit_arch of munit is

component system_ram is

	generic (
		ADDR_WIDTH : natural := 6
	);

	port (
		clk	: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector(31 downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector(31 downto 0)
	);

end component;

component mux4 is
	generic(
		LARGURA	: natural := 1
	);

	port(	
		a, b, c, d	: in  STD_LOGIC_VECTOR(LARGURA - 1 downto 0);
		sel			: in  STD_LOGIC_VECTOR(1 downto 0);
		q				: out STD_LOGIC_VECTOR(LARGURA - 1 downto 0)
	);
end component;

signal addr, memData		: STD_LOGIC_VECTOR(31 downto 0);
signal memout1, memout2	: STD_LOGIC_VECTOR(31 downto 0);
signal memout3, memout4	: STD_LOGIC_VECTOR(31 downto 0);
signal muxsel				: STD_LOGIC_VECTOR(1 downto 0);
signal we, wecond			: STD_LOGIC_VECTOR(3 downto 0);
signal chipsel				: STD_LOGIC_Vector(1 downto 0);
signal ramAddr				: natural;

begin
	muxsel <= "0" & IORD;
	mux1: mux4 generic map(32) port map(PC, ALUOUT, x"FF_FF_FF_FF", x"FF_FF_FF_FF", muxsel, addr);
	
	-- The memory blocks where split in two because of the 32 bits limitation on the software's numeric variables.
	mem1: system_ram generic map(30) port map(CLK, ramAddr, WRITEDATA, we(0), memout1);
	mem2: system_ram generic map(30) port map(CLK, ramAddr, WRITEDATA, we(1), memout2);
	mem3: system_ram generic map(30) port map(CLK, ramAddr, WRITEDATA, we(2), memout3);
	mem4: system_ram generic map(30) port map(CLK, ramAddr, WRITEDATA, we(3), memout4);
	
	mux2: mux4 generic map(32) port map(memout1, memout2, memout3, memout4, chipsel, memData);
	mux3: mux4 generic map(4) port map("0001", "0010", "0100", "1000", addr(31 downto 30), wecond);
	
	we <= wecond when MEMWRITE = '1' else "0000";
	
	ramAddr <= to_integer(unsigned(addr(29 downto 0)));
	
	process(RESET, IRWRITE, addr)
	begin
		if rising_edge(CLK) then
			chipsel <= addr(31 downto 30);
		end if;
	end process;
		
	-- ramAddr <= to_integer(unsigned(addr(7 downto 0)));
	-- mem: system_ram generic map(8) port map(CLK, ramAddr, WRITEDATA, MEMWRITE, memData);
		
	-- Instruction register
	process(RESET, IRWRITE, memData)
	begin
		if (RESET = '0') then
			INSTRUCTION <= x"00_00_00_00";
		elsif (IRWRITE = '1') then
			INSTRUCTION <= memData;
		end if;
	end process;
	
	-- Memory data register
	process(RESET, MEMREAD, memData)
	begin
		if (RESET = '0') then
			MEMORYDATA <= x"00_00_00_00";
		elsif (MEMREAD = '1') then
			MEMORYDATA <= memData;
		end if;
	end process;
	
end;
