library ieee;
use ieee.std_logic_1164.all;
library cute_lib;
use cute_lib.cute_pkg.all;

entity testbench is
-- empty
end testbench;

architecture tb of testbench is

  component ps2_master is
    port (
    clk     : in  sl;
    rst_n   : in  sl;
    tdata   : in  slv8;
    tvalid  : in  sl;
    tready  : out sl := '0';
    ps2_clk : out sl := '0';
    ps2_data : out sl := '0'
  );
  end component;

  constant CLK_PERIOD : time := 10 ns;
  signal clk   : sl := '0';
  signal rst_n : sl := '1';
  signal ps2_data : sl;
  signal tready : sl;

  procedure print_data
  is begin
    info(to_info_string(ps2_data));
    info("ready: " & to_string(tready));
    wait_clk(2, clk);
  end procedure;
begin

  dut : ps2_master
  port map
  (
    clk      => clk,
    rst_n    => rst_n,
    tdata    => "00000000",
    tvalid   => '0',
    tready   => tready,
    ps2_clk  => open,
    ps2_data => ps2_data
  );

  process
  is
    variable counter : integer := 0;
    constant COUNTER_LIMIT : integer := 400;
  begin
    if (counter >= COUNTER_LIMIT) then
      assert false report "Timeout..." severity warning;
      wait;
    end if;
    counter := counter + 1;
    clk <= not clk;
    wait for CLK_PERIOD/2;
  end process;

  process
  begin
    wait_clk(10, clk);
    rst_n <= '0';
    wait_clk(10, clk);
    rst_n <= '1';

    for i in 0 to 100 loop
      print_data;
    end loop;
    assert false report "Finished! " severity note;
    wait;
  end process;

end tb;

