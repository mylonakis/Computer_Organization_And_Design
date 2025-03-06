library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_Reset is
	 Port ( CLK : in  STD_LOGIC;
           WE : in  STD_LOGIC;
			  RESET : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0)
			 );
end Register_Reset;

architecture Behavioral of Register_Reset is

signal temp: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	process(CLK,RESET)
	begin
		
		IF RESET = '1' THEN
			temp <= "00000000000000000000000000000000";
		ELSIF rising_edge(CLK) THEN
			IF WE='1' THEN temp <= Data;
			END IF;
		END IF;
	end process;
	
	Dout <= temp after 5 ns;


end Behavioral;