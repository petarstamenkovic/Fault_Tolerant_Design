library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use work.variable_io_package.all;

entity mac is
    Port ( clk_i : in std_logic;
           u_i : in STD_LOGIC_VECTOR (input_width-1 downto 0);
           b_i : in STD_LOGIC_VECTOR (input_width-1 downto 0);
           sec_i : in STD_LOGIC_VECTOR (2*input_width-1 downto 0);
           sec_o : out STD_LOGIC_VECTOR (2*input_width-1 downto 0));
end mac;

architecture Behavioral of mac is
    signal reg_s : STD_LOGIC_VECTOR (2*input_width-1 downto 0):=(others=>'0');
begin
    process(clk_i)
    begin
        if (clk_i'event and clk_i = '1')then
            reg_s <= sec_i;
        end if;
    end process;
    
    sec_o <= std_logic_vector(signed(reg_s) + (signed(u_i) * signed(b_i)));
    
end Behavioral;