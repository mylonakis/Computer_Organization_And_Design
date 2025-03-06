library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2x1 is
    Port ( In0 : in  STD_LOGIC_VECTOR (31 downto 0);
           In1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           Output : out  STD_LOGIC_VECTOR (31 downto 0));
end Mux_2x1;

architecture Behavioral of Mux_2x1 is

signal tempOut: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	tempOut <= In0 when Sel = '0' else
				 In1;
	
	Output <= tempOut after 5 ns;
end Behavioral;

