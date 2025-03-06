library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_Register is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           WE : in  STD_LOGIC;
           Data : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end PC_Register;

architecture Behavioral of PC_Register is

signal temp: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	process(Clock)
	begin
		IF rising_edge(Clock) THEN
			IF Reset='1' THEN temp <= "00000000000000000000000000000000";
			ELSIF WE='1' THEN temp <= Data;
			END IF;
		END IF;
	end process;
	
	Dout <= temp after 5 ns;

end Behavioral;