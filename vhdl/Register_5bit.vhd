library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Register_5bit is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           WrEn : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout : out  STD_LOGIC_VECTOR (4 downto 0));
end Register_5bit;

architecture Behavioral of Register_5bit is

signal temp: STD_LOGIC_VECTOR (4 downto 0);

begin
	
	process(Clock,Reset)
	begin
		
		IF Reset = '1' THEN
			temp <= "00000";
		ELSIF rising_edge(Clock) THEN
			IF WrEn='1' THEN temp <= Data;
			END IF;
		END IF;
	end process;
	
	Dout <= temp after 5 ns;

end Behavioral;