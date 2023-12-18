#1;bold 2;low intensity 4;Underline 5;Blink 8;invis 9;strike
BLK	= \033[30m
RED	= \033[31m
GRN	= \033[32m
BRN	= \033[33m
BLU	= \033[34m
PUR	= \033[35m
CYN	= \033[36m
LGR	= \033[37m
RST	= \033[0m
NAME		:=	minishell
UNAME_S 	:= $(shell uname -s)
#---------------Directories----------------------
SRC_D		:=	src/
BUILD_D		:=	.build/
LIB_D		:=	libft/ $(HOME)/.brew/opt/readline/lib/
INC			:=	inc/ libft/inc/ $(HOME)/.brew/opt/readline/include/

#---------------Add .c / .h here \/--------------
BUILTIN		:=	env.c	export.c	unset.c	echo.c	pwd.c	cd.c	exit.c
UTILS		:=	free_return.c	export_unset_utils.c	env_utils.c		\
				getvar.c	extract_var_data.c	extract_var_name.c		\
				add_to_matrix.c	free_join.c	count_strings.c	only_spaces.c\
				fprint_debug.c	fprint_matrix.c	is_meta.c	is_string.c\
				token_struct_utils.c	parse_tokens_utils.c	fatal_error.c\
				pipes_utils.c	free_shell.c free_cmds.c	free_tokens.c\
				close_fds.c	check_env_arg.c

PARSING		:=	parse_tokens.c	tokenizer.c	tokenization_utils.c expand_var.c\
				expand_string.c	init_cmd_struct.c open_io.c	set_fd_to_pipe.c\
				check_cmd_filetype.c

SRC			:=	main.c	exec_builtins.c	init_env.c	prompt.c	signal_handler.c	\
				update_history.c	execute.c	heredoc.c

LIB			:=	ft readline
#FRAMEWORK	:=	OpenGL	AppKit
#----------------------IGNORE--------------------
#------------------------------------------------
SRC			+=	$(BUILTIN:%=builtin/%) $(UTILS:%=utils/%) $(PARSING:%=parsing/%)
SRC			:=	$(SRC:%=$(SRC_D)%)
OBJ 		:=	$(SRC:$(SRC_D)%.c=$(BUILD_D)%.o)
DEPS        :=	$(OBJ:.o=.d)
#------------------------------------------------
#----------------Linux libs \/-------------------
ifeq ($(UNAME_S),Linux)
LIB_D		:=	libft/
INC			:=	inc/ libft/inc/
LIB			:=	ft readline history
FRAMEWORK	:=	
endif
#-------------------------------------------------
RM			:=	rm -rf
CC			:=	gcc
DIR_DUP     =	mkdir -p "$(@D)"
#-MMD -MP = Used to add dependencies during precomp. (for .h)
CPPFLAGS    :=	-MMD -MP $(addprefix -I,$(INC))
CFLAGS		:=	-Wextra -Werror -Wall
# -(r)eplace the older objects, -(c)reate if no lib, -s index stuff
AR          :=	ar
ARFLAGS     :=	-r -c -s
LDFLAGS     :=	$(addprefix -L,$(dir $(LIB_D)))
LDLIBS      :=	$(addprefix -l,$(LIB))
LDFMWK		:=	$(addprefix -framework ,$(FRAMEWORKS))
MAKEFLAGS   += --no-print-directory
#-----------------------------all------------------------------------
all		:	$(NAME)
#-----------------------------NAME-----------------------------------
$(NAME)	:	$(OBJ)
			$(MAKE) complib
			${CC} $(LDFLAGS) $(OBJ) $(LDLIBS) $(LDFMWK) -o $(NAME)
			$(info MAKING $(NAME).....)
			echo "\033[5;32m\t\tFinished compiling $(NAME) !!! $(CLR)"
#------------------------OBJ COMPILATION-----------------------------
$(BUILD_D)%.o	:	$(SRC_D)%.c
			$(DIR_DUP)
			$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@
			echo created $(@F)

-include	${DEPS}
#----------------------------COMPLIB---------------------------------
complib	:
	$(info COMPILING THE LIBS)
	@$(MAKE) -s -C libft
ifeq ($(UNAME_S),Linux)
endif
ifeq ($(UNAME_S),Darwin)
endif
#----------------------------CLEAN-----------------------------------
clean	:
	$(RM) $(OBJ) $(DEPS)
	$(MAKE) -C libft clean
ifeq ($(UNAME_S),Darwin)
else
endif
	echo "$(CYN) \t\tALL CLEANED $(RST)"
#----------------------------FCLEAN----------------------------------
fclean	:	clean
	$(RM) $(NAME)
	$(MAKE) -C libft fclean
ifeq ($(UNAME_S),Darwin)
else
endif
	echo "\033[5;36m \t\tALL F*NG CLEANED !!! $(RST)"
#------------------------------RE------------------------------------
re		:	fclean all

.PHONY	:	all clean fclean re
.SILENT :
