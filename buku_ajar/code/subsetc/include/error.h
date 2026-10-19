// Berkas: include/error.h
// Pelaporan kesalahan dengan lokasi.

#ifndef SUBSETC_ERROR_H
#define SUBSETC_ERROR_H

void error_at(const char *filename, int line, int column,
              const char *message);

#endif /* SUBSETC_ERROR_H */
