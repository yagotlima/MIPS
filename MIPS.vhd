LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity MIPS is
	port(
		clk, reset	: in  STD_LOGIC
	);
end entity;

architecture mips_arch of MIPS is

component cunit is
	port(
		CLK, RESET, ZERO				: in  STD_LOGIC;
		OP									: in  STD_LOGIC_VECTOR(5 downto 0);
		FUNCT								: in  STD_LOGIC_VECTOR(3 downto 0);
		REGWRITE, REGDST, IORD		: out STD_LOGIC;
		MEMREAD, MEMWRITE				: out STD_LOGIC;
		PCSOURCE							: out STD_LOGIC_VECTOR(1 downto 0);
		ALUCONTROL						: out STD_LOGIC_VECTOR(3 downto 0);
		ALUSRCB							: out STD_LOGIC_VECTOR(1 downto 0);
		ALUSRCA							: out STD_LOGIC;
		MEMTOREG, IRWRITE				: out STD_LOGIC;
		PCENABLE							: out STD_LOGIC
	);
end component;

component single_port_ram
	generic 
	(
		DATA_WIDTH : natural;
		ADDR_WIDTH : natural
	);
	port (
		clk	: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
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

begin
	-- TODO --
end;
