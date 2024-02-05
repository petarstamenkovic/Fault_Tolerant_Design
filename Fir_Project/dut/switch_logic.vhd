library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;
use work.variable_io_package.all;

entity switch_logic is
--generic(NUM_SPARES : integer := 3;
--        NUM_MODULAR : integer := 4;   
--        output_data_width : integer := 24); 
       Port (
            clk  : in std_logic;
            in1  : in MAC_OUT_ARRAY(NUM_MODULAR-1 downto 0);
            in2  : in MAC_OUT_ARRAY(NUM_SPARES-1 downto 0);
            comp_out : in std_logic_vector(NUM_MODULAR-1 downto 0);
            out1 : out MAC_OUT_ARRAY(NUM_MODULAR-1 downto 0) 
        );
end switch_logic;

architecture Behavioral of switch_logic is
    signal zero_vector : std_logic_vector(NUM_MODULAR-1 downto 0) := (others => '0');
    signal sel_zero : std_logic_vector(log2c(NUM_SPARES+1)-1 downto 0):= (others => '0');
    type SEL_TYPE is array(NUM_MODULAR-1 downto 0) of std_logic_vector(log2c(NUM_SPARES+1)-1 downto 0);
    signal sel : SEL_TYPE := (others => (others => '0'));
    signal fail : std_logic_vector(log2c(NUM_SPARES+1)-1 downto 0):= (std_logic_vector(to_unsigned(1, log2c(NUM_SPARES+1))));
begin

mux_generation:
process(comp_out,in1,in2,sel_zero,sel)
begin       
    out1 <= (others => (others => '0')); 
    for i in 0 to NUM_MODULAR-1 loop
           if(sel(i) = sel_zero) then 
                out1(i) <= in1(i);
           else     
                for j in 1 to NUM_SPARES loop
                if(sel(i) = std_logic_vector(to_unsigned(j,2))) then
                    out1(i) <= in2(j-1);
                end if;
                end loop;
           end if;     
    end loop;    
end process;

failing_mechanism:
process(clk)
begin 
    if(rising_edge(clk) or comp_out /= zero_vector) then
        --if(comp_out /= zero_vector) then
            for k in 0 to NUM_MODULAR-1 loop
                if(comp_out(k) = '1') then
                    sel(k) <= fail;
                    fail <= std_logic_vector(unsigned(fail) + TO_UNSIGNED(1,log2c(NUM_SPARES+1)));
                    exit;
                end if;          
             end loop;
        else 
            sel <= sel;
            fail <= fail;
        end if;    
     --end if;   
end process;

end Behavioral;
