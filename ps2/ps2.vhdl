library ieee;
use ieee.std_logic_1164.all;
library cute_lib;
use cute_lib.cute_pkg.all;

entity ps2_master is
  port (
  clk      : in  sl;
  rst_n    : in  sl;
  tdata    : in  slv8;
  tvalid   : in  sl;
  tready   : out sl := '0';
  ps2_clk  : out sl := '0';
  ps2_data : out sl := '1'
);
end ps2_master;

architecture behavior of ps2_master is
  type state_t is (WAITING, TRANSMITTING, DONE);
  signal state : state_t := WAITING;
  signal tdata_latch : slv8 := (others => '0');
  signal parity : sl := '0';

  pure function get_parity (constant data : slv8)
    return sl
  is begin
    return xor data;
  end function;
begin

  main: process(clk)
  is
    variable counter : integer := 0;
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        tready <= '0';
        ps2_clk <= '0';
        ps2_data <= '0';
        state <= WAITING;
        tdata_latch <= (others => '0');
        counter     := 0;
      else
        case state is
          when WAITING =>
            tready <= '1';
            if tvalid = '1' then
              state <= TRANSMITTING;
              tdata_latch <= tdata;
              parity <= get_parity(tdata);
            end if;
          when TRANSMITTING =>
            tready <= '0';
            ps2_clk <= not ps2_clk;
            -- data like changes when clk is high and valid when low
            if ps2_clk = '0' then
              if counter = 0 then
                -- start bit
                ps2_data <= '0';
              elsif (counter >= 1) and (counter < 9) then
                -- data bit
                ps2_data <= tdata_latch(0);
                tdata_latch <= '0' & tdata_latch(7 downto 1);
              else
                -- parity bit
                ps2_data <= parity;
                state <= DONE;
              end if;
              counter := counter + 1;
            end if;
          when DONE =>
            ps2_clk <= '0';
            ps2_data <= '1';
            state <= DONE;
        end case;
      end if;
    end if;
  end process;

end behavior;
