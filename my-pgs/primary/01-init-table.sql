CREATE TABLE public.users (
	uid serial NOT NULL,
	user_name varchar NOT NULL,
	CONSTRAINT users_pk PRIMARY KEY (uid)
);

INSERT INTO public.users (user_name) VALUES ('alice'), ('bob'), ('charlie');
