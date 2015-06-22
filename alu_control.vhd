LIBRARY	ieee;
USE		ieee.std_logic_1164.all;

entity alu_control is
	port(
		ALUOP			: in  STD_LOGIC_VECTOR(1 downto 0);
		FUNCT			: in  STD_LOGIC_VECTOR(3 downto 0);
		ALUCONTROL	: out STD_LOGIC_VECTOR(3 downto 0)
	);
end entity;

architecture alu_control_arch of alu_control is
begin
	proc: process(ALUOP, FUNCT)
		variable aux : STD_LOGIC_VECTOR(3 downto 0);
	begin
		case FUNCT is
			when "0000" => aux := "0010";
			when "0010" => aux := "0110";
			when "0100" => aux := "0000";
			when "0101" => aux := "0001";
			when "1010" => aux := "0111";
			when others => aux := "1111";
		end case;
	
		case ALUOP is
			when "00"   => ALUCONTROL <= "0010";
			when "01"   => ALUCONTROL <= "0110";
			when others => ALUCONTROL <= aux;
		end case;
	end process;
	
end;
