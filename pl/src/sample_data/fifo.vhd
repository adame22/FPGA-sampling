Library UNISIM;
use UNISIM.vcomponents.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;
-- arch:
    type slv_2d is array (natural range <>) of std_logic_vector;
    signal mic         : slv_2d(0 to 63)(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => (others => '0'));
    
    -- FIFOs
    signal di, do      : slv_2d(mic'range)(23 downto 0)
    signal empty       : std_logic_vector(mic'range); -- output empty
    signal full        : std_logic_vector(mic'range); -- output full
    signal almostempty : std_logic_vector(mic'range); -- output almost empty
    signal almostfull  : std_logic_vector(mic'range); -- output almost full
    signal rden        : std_logic_vector(mic'range); -- input read enable
    signal wren        : std_logic_vector(mic'range); -- input write enable
-- arch begin:
    fifos: for n in mic'range generate
        FIFO_DUALCLOCK_MACRO_inst : FIFO_DUALCLOCK_MACRO
            generic map (
                device => "7SERIES",              -- Target Device: "VIRTEX5", "VIRTEX6", "7SERIES"
                almost_full_offset  => x"0080",   -- Sets almost full threshold
                almost_empty_offset => x"0080",   -- Sets the almost empty threshold
                data_width => 24,                 -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
                fifo_size => "36kb",              -- Target BRAM, "18Kb" or "36Kb"
                first_word_fall_through => false) -- Sets the FIFO FWFT to TRUE or FALSE
            port map (
                almostempty => almostempty(n),   -- 1-bit output almost empty
                almostfull => almostfull(n),     -- 1-bit output almost full
                do => do(n),                     -- Output data, width defined by DATA_WIDTH parameter
                empty => empty(n),               -- 1-bit output empty
                full => full(n),                 -- 1-bit output full
                rdcount => open,                 -- Output read count, width determined by FIFO depth
                rderr => open                    -- 1-bit output read error
                wrcount => open,                 -- Output write count, width determined by FIFO depth
                wrerr => open,                   -- 1-bit output write error
                di => di(n),                     -- Input data, width defined by DATA_WIDTH parameter
                rdclk => S_AXI_ACLK,             -- 1-bit input read clock 
                rden => rden(n),                 -- 1-bit input read enable
                rst => rst,                      -- 1-bit input reset  (Active low or high???)
                wrclk => clk,                    -- 1-bit input write clock (Logic clock)
                wren => wren(n)                  -- 1-bit input write enable
        );
    end generate fifos;