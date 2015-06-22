LIBRARY	ieee;
USE		ieee.std_logic_1164.all;
USE		ieee.numeric_std.all;

entity cunit is
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
end entity;

architecture cunit_arch of cunit is

component microcode_rom is
	generic(
		DATA_WIDTH : natural := 18;
		ADDR_WIDTH : natural := 4
	);

	port(
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q		: out STD_LOGIC_VECTOR((DATA_WIDTH -1) downto 0)
	);
end component;

component alu_control is
	port(
		ALUOP			: in  STD_LOGIC_VECTOR(1 downto 0);
		FUNCT			: in  STD_LOGIC_VECTOR(3 downto 0);
		ALUCONTROL	: out STD_LOGIC_VECTOR(3 downto 0)
	);
end component;

signal romAddr						: STD_LOGIC_VECTOR(3 downto 0);
signal romOut						: STD_LOGIC_VECTOR(17 downto 0);

signal seq							: STD_LOGIC_VECTOR(1 downto 0);
signal pcwrite, pcwritecond	: STD_LOGIC;
signal aluop						: STD_LOGIC_VECTOR(1 downto 0);

begin
	rom1: microcode_rom port map(to_integer(unsigned(romAddr)), romOut);
	aluctl: alu_control port map(aluop, FUNCT, ALUCONTROL);
	
	seq			<= romOut(1 downto 0);
	pcwritecond	<= romOut(2);
	pcwrite		<= romOut(3);
	PCSOURCE		<= romOut(5 downto 4);
	IRWRITE		<= romOut(6);
	MEMWRITE		<= romOut(7);
	MEMREAD		<= romOut(8);
	IORD			<= romOut(9);
	MEMTOREG		<= romOut(10);
	REGDST		<= romOut(11);
	REGWRITE		<= romOut(12);
	ALUSRCB		<= romOut(14 downto 13);
	ALUSRCA		<= romOut(15);
	aluop			<= romOut(17 downto 16);
	
	PCENABLE		<= pcwrite or (pcwritecond and ZERO);
	
end;
