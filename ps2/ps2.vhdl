library ieee;
use ieee.std_logic_1164.all;
library cute_lib;
use cute_lib.cute_pkg.all;

entity ps2_master is
  port (
  clk     : in  sl;
  rst_n   : in  sl;
  tdata   : in  slv8;
  tvalid  : in  sl;
  tready  : out sl := '0';
  ps2_clk : out sl := '0';
  ps2_data : out sl := '0'
);
end ps2_master;

architecture behavior of ps2_master is
  constant my_data_k : slv8 := "00011111";
  signal tdata_latch : slv8 := (others => '0');
  signal done : sl := '0';
begin

  main : process(clk)
  is
  begin
    if rising_edge(clk) then
      if (rst_n = '0') or (done = '1') then
        tready <= '0';
      else
        tready <= '1';
      end if;
    end if;
  end process;

  data_driver : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        ps2_data <= '0';
        tdata_latch <= my_data_k;
      else
        if (ps2_clk = '1') and (tready = '1') then
          ps2_data <= tdata_latch(7);
          tdata_latch <= tdata_latch(6 downto 0) & '0';
        end if;
      end if;
    end if;
  end process;

  clk_driver : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        ps2_clk <= '0';
      else
        -- div by 2
        ps2_clk <= not ps2_clk;
      end if;
    end if;
  end process;

  logger : process(clk)
  is
    variable counter : integer := 0;
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        counter := 0;
        done <= '0';
      elsif rising_edge(ps2_clk) then
        info(to_string(counter));
        counter := counter + 1;
        if counter >= 7 then
          done <= '1';
        end if;
      end if;
    end if;
  end process;

end behavior;
