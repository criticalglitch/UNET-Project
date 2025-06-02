from sigmf.sigmffile import fromfile as from_sigmf_file
import numpy as np

# Matlab will handle finding files and calculating the data contained in the files
# Python is only necessary to *load* the data from the files
def handle_sigmf(path):
    handle = from_sigmf_file(path)
    handle.read_samples() # returns all timeseries data
    meta = handle.get_global_info() # returns 'global' dictionary
    channels = meta['core:num_channels'] # number of different antenna channels
    sample_rate = meta['core:sample_rate'] # sample rate
    num_points = len(handle)
    reals = np.ascontiguousarray(np.real(handle)) # reals/inphase
    imags = np.ascontiguousarray(np.imag(handle)) # imaginaries/quadrature
    return channels, sample_rate, num_points, reals, imags

c, sr, num, reals, imags = handle_sigmf(file_to_read) # Matlab will define file_to_read