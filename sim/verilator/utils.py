import numpy as np

def to_complex(val: int) -> complex:
    """Helper function to convert a 32-bit packed integer into a Python complex number."""
    # Assumes DUT format: [31:16] is imaginary, [15:0] is real
    real = val & 0xFFFF
    imag = val >> 16
    # Manually handle sign extension for 16-bit signed numbers
    if real & 0x8000:
        real -= 0x10000
    if imag & 0x8000:
        imag -= 0x10000
    return complex(real, imag)

def generate_data_vector(vec_size = 1,  lower_bound = -1000, upper_bound = 1000, data_type = np.int16):
    return np.random.randint(lower_bound, upper_bound, size=vec_size, dtype=data_type)

def pack_real_imag_vec(real_vec, imag_vec):
  bits = real_vec.dtype.itemsize * 8
  real_dtype = np.dtype(f'uint{bits}')
  packed_dtype = np.dtype(f'uint{2 * bits}')
  upper = imag_vec.astype(packed_dtype) << bits
  lower = real_vec.astype(real_dtype)
  return upper | lower

def unpack_real_imag_vec(packed_vec, target_dtype):
  target_dtype = np.dtype(target_dtype)
  bits = target_dtype.itemsize * 8
  mask = (1 << bits) - 1
  real_unsigned = packed_vec & mask
  imag_unsigned = packed_vec >> bits
  real_vec = real_unsigned.astype(target_dtype)
  imag_vec = imag_unsigned.astype(target_dtype)
  
  return real_vec, imag_vec