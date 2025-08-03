import numpy as np

import utils
import cocotb

from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


@cocotb.test()
async def test_complex_mean_square(dut):
    """Test for the Complex Mean Square module."""
    cocotb.start_soon(Clock(dut.i_clk, 10, units="ns").start())
    dut._log.info("Starting Complex Mean Square test")

    log2n = 3
    N = 2**log2n

    # ===== Gen Data =======
    y_real = utils.generate_data_vector(N)
    y_imag = utils.generate_data_vector(N) 

    # add random dist from the original data
    y_hat_real = y_real + np.random.randint(-50, 50, size=N, dtype=np.int16)
    y_hat_imag = y_imag + np.random.randint(-50, 50, size=N, dtype=np.int16)

    y_packed = utils.pack_real_imag_vec(y_real, y_imag)
    y_hat_packed = utils.pack_real_imag_vec(y_hat_real, y_hat_imag)

    # ==== Feeding Data ====
    dut.i_en.value = 0
    dut.i_arst.value = 1
    await ClockCycles(dut.i_clk, 2)
    dut.i_arst.value = 0
    await RisingEdge(dut.i_clk)
    
    dut.i_log2_samples.value = log2n
    dut.i_en.value = 1
    await RisingEdge(dut.i_clk)
    dut.i_en.value = 0

    await RisingEdge(dut.i_clk)
    await RisingEdge(dut.i_clk)
    await RisingEdge(dut.i_clk)


    dut._log.info(f"Driving {N} complex numbers into the DUT...")
    for i in range(N):
        await RisingEdge(dut.i_clk)
        dut.i_valid = 1
        dut.i_y.value = int(y_packed[i])
        dut.i_y_hat.value = int(y_hat_packed[i])
        dut._log.info(f"Sent cycle {i+1}: y={utils.to_complex(dut.i_y.value)}, y_hat={utils.to_complex(dut.i_y_hat.value)}")

    dut._log.info("Waiting for 'done' signal...")
    await RisingEdge(dut.o_valid)
    
    full_value = dut.o_data.value.integer
    packed_data = np.array([full_value])
    dut_real, dut_imag = utils.unpack_real_imag_vec(packed_data, np.int32)

    # Get the integer values from the resulting single-element arrays

    y_complex = y_real.astype(np.int64) + 1j * y_imag.astype(np.int64)
    y_hat_complex = y_hat_real.astype(np.int64) + 1j * y_hat_imag.astype(np.int64)
    diff_vector = y_complex - y_hat_complex
    squared_vector = diff_vector * diff_vector
    total_sum = np.sum(squared_vector)
    
    expected_real = int(total_sum.real) >> log2n
    expected_imag = int(total_sum.imag) >> log2n

    dut._log.info(f"DUT Result:      complex(real={dut_real}, imag={dut_imag})")
    dut._log.info(f"Expected Result: complex(real={expected_real}, imag={expected_imag})")
    
    assert dut_real[0] == expected_real, f"Real part mismatch! Expected {expected_real}, got {dut_real}"
    assert dut_imag[0] == expected_imag, f"Imaginary part mismatch! Expected {expected_imag}, got {dut_imag}"
    
    dut._log.info("Test Passed!")
