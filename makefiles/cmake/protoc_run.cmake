# Runs protoc for s2sdk_protobufs() (cmake -P): the arguments in PROTOC_ARGS,
# the compiler in PROTOC.
#
# The SDK's protos are Valve's, as the game ships them: none says which syntax
# it is (protoc assumes proto2, which is right) and some import a file they do
# not use. protoc reports both for every proto it reads, imports included, on
# every build. Those two notes are dropped here; anything else protoc says -- an
# error, any other warning -- still gets through, and a failed run still fails.

execute_process(
	COMMAND "${PROTOC}" ${PROTOC_ARGS}
	RESULT_VARIABLE rc
	OUTPUT_VARIABLE out
	ERROR_VARIABLE err
)

foreach(stream out err)
	set(text "${${stream}}")
	string(REGEX REPLACE "[^\n]*No syntax specified for the proto file[^\n]*\n?" "" text "${text}")
	string(REGEX REPLACE "[^\n]*: warning: Import [^\n]* is unused\\.[^\n]*\n?" "" text "${text}")
	string(STRIP "${text}" text)
	if(text)
		message("${text}")
	endif()
endforeach()

if(NOT rc EQUAL 0)
	message(FATAL_ERROR "protoc failed (${rc})")
endif()
