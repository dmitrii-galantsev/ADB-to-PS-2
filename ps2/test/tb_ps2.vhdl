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
    clk      : in  sl;
    rst_n    : in  sl;
    tdata    : in  slv8;
    tvalid   : in  sl;
    tready   : out sl := '0';
    ps2_clk  : out sl := '0';
    ps2_data : out sl := '0'
  );
  end component;

  constant CLK_PERIOD : time := 10 ns;
  signal clk   : sl := '0';
  signal rst_n : sl := '0';
  signal tvalid : sl := '0';
  signal ps2_clk : sl;
  signal ps2_data : sl;
  signal tready : sl;

  procedure print_wait
  is begin
    info("ready: " & to_string(tready) & HT &
         "data:  " & to_string(ps2_data) & HT &
         "clk:  " & to_string(ps2_clk));
    wait_clk(2, clk);
  end procedure;
begin

  dut : ps2_master
  port map
  (
    clk      => clk,
    rst_n    => rst_n,
    tdata    => "00000000",
    tvalid   => tvalid,
    tready   => tready,
    ps2_clk  => ps2_clk,
    ps2_data => ps2_data
  );

  process
  is
    variable counter : integer := 0;
    constant COUNTER_LIMIT : integer := 100;
  begin
    if (counter >= COUNTER_LIMIT) then
      finish("Timeout...");
    end if;
    counter := counter + 1;
    clk <= not clk;
    wait for CLK_PERIOD/2;
  end process;

  process
  begin
    wait_clk(10, clk);
    info("Resetting...");
    rst_n <= '0';
    wait_clk(10, clk);
    info("Un-resetting...");
    rst_n <= '1';

    wait until tready = '1' for 1 us;
    tvalid <= '1';
    wait_clk(1, clk);

    for i in 0 to 20 loop
      print_wait;
    end loop;
    finish;
  end process;

end tb;

