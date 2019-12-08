
SRC = src
OBJ = src
OBJS=
LIBS = -lusb

SOURCES = $(SRC)/msigd.cpp
TARGETS = msigd

CC = g++
LD = $(CC)
CFLAGS = -O2 -g

all:    depend $(TARGETS)

#-------------------------------------------------
# clean
#-------------------------------------------------

clean:
	$(RM) -rf $(OBJS) $(TARGETS) $(OBJ)/msigd.o .depend doxy/*

#-------------------------------------------------
# nltool
#-------------------------------------------------

msigd: $(OBJ)/msigd.o $(OBJS)
	@echo Linking $@...
	$(LD) -o $@ $(LDFLAGS) $^ $(LIBS)

#-------------------------------------------------
# depends
#-------------------------------------------------

.depend: $(SOURCES)
	@echo creating .depend
	@rm -f ./.depend
	@for i in $(SOURCES); do \
		$(CC) $(CFLAGS) -MM $$i -MT `echo $$i | sed -e 's+$(SRC)+$(OBJ)+' -e 's+.cpp+.o+' ` >> ./.depend; \
	done

depend: .depend


#-------------------------------------------------
# generic rules
#-------------------------------------------------

$(OBJ)/%.o: $(SRC)/%.cpp
	@echo Compiling $<...
	@$(CC) $(CDEFS) $(CFLAGS) -c $< -o $@

$(OBJ)/%.pp: $(SRC)/%.cpp
	@echo Compiling $<...
	@$(CC) $(CDEFS) $(CFLAGS) -E $< -o $@

$(OBJ)/%.s: $(SRC)/%.cpp
	@echo Compiling $<...
	@$(CC) $(CDEFS) $(CFLAGS) -S $< -o $@

$(OBJ)/%.a:
	@echo Archiving $@...
	$(RM) $@
	$(AR) $(ARFLAGS) $@ $^

$(OBJ)/%.json: $(SRC)/%.cpp
	@echo Building compile database entry for $< ...
	@echo { \"directory\": \".\", >> $(TIDY_DB)
	@echo   \"command\": \"$(CC) $(CDEFS) $(CFLAGS) -c $< -o dummy.o\", >> $(TIDY_DB)
	@echo   \"file\": \"$(CURDIR)/$<\" } >> $(TIDY_DB)
	@echo "," >> $(TIDY_DB)

compile_commands_prefix:
	@echo "[" > $(TIDY_DB)

compile_commands_postfix:
	@echo "]" >> $(TIDY_DB)
