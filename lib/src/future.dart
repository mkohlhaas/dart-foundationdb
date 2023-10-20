// See foundationdb/bindings/go/src/fdb/futures.go !!!

import '../foundationdb.dart';

class Future {}

// {
// // Call an API that returns FDBFuture*, documented as returning type foo in the future
// f = fdb_something(); // this call immediately returns; FDB can do what it wants!
//
// // Wait for the Future to be *ready*. From Dart's perspective this is a BLOCKING CALL.
// if ( (fdb_future_block_until_ready(f)) != 0 ) {  // FDB can do something else!!! (fdb is a highly threaded application)
//     // Exceptional error (e.g. out of memory)
// }
//
// if ( (err = fdb_future_get_foo(f, &result)) == 0 ) {
//     // Use result
//     // In some cases, you must be finished with result before calling
//     // fdb_future_destroy() (see the documentation for the specific
//     // fdb_future_get_*() method)
// } else {
//     // Handle the error. If this is an error in a transaction, see
//     // fdb_transaction_on_error()
// }
//
// fdb_future_destroy(f);
// }
//
// abstract interface class Future {
//   get();             // specific functions for every fdb_future_get_XXX function (see below)
// }

// {
// Separate function or class member:
//   blockUntilReady(); // one generic function calling fdb_future_block_until_ready
//
// or abstract class Future and extends subclasses, e.g.
// class FutureInt64 extends Future {}
//
// class FutureInt64 implements Future {}
// class FutureKeyArray implements Future {}
// class FutureKey implements Future {}
// class FutureValue implements Future {}
// class FutureStringArray implements Future {}
// class FutureKeyValueArray implements Future {}
// class FutureKeyNil implements Future {}
//
// fdb_future_get_XXX functions:
//
// fdb_error_t fdb_future_get_int64(FDBFuture *future, int64_t *out)
//     Extracts a 64-bit integer from a pointer to FDBFuture into a caller-provided variable of type int64_t. future must represent a result of the appropriate type (i.e. must have been returned by a function documented as returning this type), or the results are undefined.
//     Returns zero if future is ready and not in an error state, and a non-zero error code otherwise (in which case the value of any out parameter is undefined).
//
// fdb_error_t fdb_future_get_key_array(FDBFuture *f, FDBKey const **out_key_array, int *out_count)
//     Extracts an array of FDBKey from an FDBFuture* into a caller-provided variable of type FDBKey*. The size of the array will also be extracted and passed back by a caller-provided variable of type int future must represent a result of the appropriate type (i.e. must have been returned by a function documented as returning this type), or the results are undefined.
//     Returns zero if future is ready and not in an error state, and a non-zero error code otherwise (in which case the value of any out parameter is undefined).
//
// fdb_error_t fdb_future_get_key(FDBFuture *future, uint8_t const **out_key, int *out_key_length)
//     Extracts a key from an FDBFuture into caller-provided variables of type uint8_t* (a pointer to the beginning of the key) and int (the length of the key). future must represent a result of the appropriate type (i.e. must have been returned by a function documented as returning this type), or the results are undefined.
//     Returns zero if future is ready and not in an error state, and a non-zero error code otherwise (in which case the value of any out parameter is undefined).
//     The memory referenced by the result is owned by the FDBFuture object and will be valid until either fdb_future_destroy(future) or fdb_future_release_memory(future) is called.
//
// fdb_error_t fdb_future_get_value(FDBFuture *future, fdb_bool_t *out_present, uint8_t const **out_value, int *out_value_length)
//     Extracts a database value from an FDBFuture into caller-provided variables. future must represent a result of the appropriate type (i.e. must have been returned by a function documented as returning this type), or the results are undefined.
//     Returns zero if future is ready and not in an error state, and a non-zero error code otherwise (in which case the value of any out parameter is undefined).
//     *out_present
//         Set to non-zero if (and only if) the requested value was present in the database. (If zero, the other outputs are meaningless.)
//     *out_value
//         Set to point to the first byte of the value.
//     *out_value_length
//         Set to the length of the value (in bytes).
//     The memory referenced by the result is owned by the FDBFuture object and will be valid until either fdb_future_destroy(future) or fdb_future_release_memory(future) is called.
//
// fdb_error_t fdb_future_get_string_array(FDBFuture *future, const char ***out_strings, int *out_count)
//     Extracts an array of null-terminated C strings from an FDBFuture into caller-provided variables. future must represent a result of the appropriate type (i.e. must have been returned by a function documented as returning this type), or the results are undefined.
//     Returns zero if future is ready and not in an error state, and a non-zero error code otherwise (in which case the value of any out parameter is undefined).
//     *out_strings
//         Set to point to the first string in the array.
//     *out_count
//         Set to the number of strings in the array.
//     The memory referenced by the result is owned by the FDBFuture object and will be valid until either fdb_future_destroy(future) or fdb_future_release_memory(future) is called.
//
// fdb_error_t fdb_future_get_keyvalue_array(FDBFuture *future, FDBKeyValue const **out_kv, int *out_count, fdb_bool_t *out_more)
//     Extracts an array of FDBKeyValue objects from an FDBFuture into caller-provided variables. future must represent a result of the appropriate type (i.e. must have been returned by a function documented as returning this type), or the results are undefined.
//     Returns zero if future is ready and not in an error state, and a non-zero error code otherwise (in which case the value of any out parameter is undefined).
//     *out_kv
//         Set to point to the first FDBKeyValue object in the array.
//     *out_count
//         Set to the number of FDBKeyValue objects in the array.
//     *out_more
//         Set to true if (but not necessarily only if) values remain in the key range requested (possibly beyond the limits requested).
//     The memory referenced by the result is owned by the FDBFuture object and will be valid until either fdb_future_destroy(future) or fdb_future_release_memory(future) is called.
// }

// {
// fdb functions returning an FDBFuture*:

// FDBFuture *fdb_database_reboot_worker(FDBDatabase *database, uint8_t const *address, int address_length, fdb_bool_t check, int duration)
// int64()

// FDBFuture *fdb_database_force_recovery_with_data_loss(FDBDatabase *database, uint8_t const *dcId, int dcId_length)
// empty value

// FDBFuture *fdb_database_create_snapshot(FDBDatabase *database, uint8_t const *snapshot_command, int snapshot_command_length)
// empty value

// FDBFuture *fdb_transaction_get_read_version(FDBTransaction *transaction)
// int64()

// FDBFuture *fdb_transaction_get(FDBTransaction *transaction, uint8_t const *key_name, int key_name_length, fdb_bool_t snapshot)
// value

// FDBFuture *fdb_transaction_get_estimated_range_size_bytes(FDBTransaction *tr, uint8_t const *begin_key_name, int begin_key_name_length, uint8_t const *end_key_name, int end_key_name_length)
// int64()

// FDBFuture *fdb_transaction_get_range_split_points(FDBTransaction *tr, uint8_t const *begin_key_name, int begin_key_name_length, uint8_t const *end_key_name, int end_key_name_length, int64_t chunk_size)
// key array

// FDBFuture *fdb_transaction_get_key(FDBTransaction *transaction, uint8_t const *key_name, int key_name_length, fdb_bool_t or_equal, int offset, fdb_bool_t snapshot)
// key

// FDBFuture *fdb_transaction_get_addresses_for_key(FDBTransaction *transaction, uint8_t const *key_name, int key_name_length)
// string array

// FDBFuture *fdb_transaction_get_range(FDBTransaction *transaction, uint8_t const *begin_key_name, int begin_key_name_length, fdb_bool_t begin_or_equal, int begin_offset, uint8_t const *end_key_name, int end_key_name_length, fdb_bool_t end_or_equal, int end_offset, int limit, int target_bytes, FDBStreamingMode mode, int iteration, fdb_bool_t snapshot, fdb_bool_t reverse)
// key value array

// FDBFuture *fdb_transaction_commit(FDBTransaction *transaction)
// empty value

// FDBFuture *fdb_transaction_get_approximate_size(FDBTransaction *transaction)
// int64()

// FDBFuture *fdb_transaction_get_versionstamp(FDBTransaction *transaction)
// key

// FDBFuture *fdb_transaction_watch(FDBTransaction *transaction, uint8_t const *key_name, int key_name_length)
// empty value

// FDBFuture *fdb_transaction_on_error(FDBTransaction *transaction, fdb_error_t error)
// empty value (but special treatment necessary; see documentation: https://apple.github.io/foundationdb/api-c.html)

// }
