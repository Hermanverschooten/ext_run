#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include "erl_nif.h"

/* Close all non-terminal file descriptors. */
void
close_all_non_term_fd(void)
{
	int n;
	int max = 1024;
#ifdef RLIMIT_NOFILE
	struct rlimit lim;

	if (!getrlimit(RLIMIT_NOFILE, &lim))
		max = lim.rlim_max;
#endif
	for (n = 3; n < max; n++)
		close(n);
}

char *
alloc_and_copy_to_cstring(ErlNifBinary *string)
{
	char *str = (char *) enif_alloc(string->size + 1);
	strncpy(str, (char *)string->data, string->size);
	str[string->size] = 0;
	return str;
}

void free_cstring(char * str) {
	enif_free(str);
}

ERL_NIF_TERM mk_atom(ErlNifEnv* env, const char* atom)
{
	ERL_NIF_TERM ret;

	if (!enif_make_existing_atom(env, atom, &ret, ERL_NIF_LATIN1))
	{
		return enif_make_atom(env, atom);
	}

	return ret;
}

static ERL_NIF_TERM
  ex_run(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  int pid;

  const char *new_argv[4];

  ErlNifBinary string;

  if(argc != 1 || ! enif_inspect_binary(env, argv[0], &string))
    return enif_make_badarg(env);

  char *cmdline = alloc_and_copy_to_cstring(&string);

  new_argv[0] = "/bin/sh";
  new_argv[1] = "-c";
  new_argv[2] = cmdline;
  new_argv[3] = NULL;

  pid = fork();

  if( pid == 0 ) {
    setpgid(pid, pid);
    close_all_non_term_fd();
    execvp("/bin/sh", (char * const *) new_argv);
    free_cstring(cmdline);
    exit(1);
  }
  free_cstring(cmdline);
  return mk_atom(env, "ok");
}

static ErlNifFunc nif_funcs[] =
{
  {"run", 1, ex_run, 0 }
};

ERL_NIF_INIT(Elixir.ExtRun, nif_funcs, NULL, NULL, NULL, NULL)
