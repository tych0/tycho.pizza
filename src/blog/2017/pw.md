---
title: pw, a stateless password generation tool
date: 2017-12-16
tags: passwords, tools, rust
---

Ahoy! Recently, I have been working on a new stateless password generation
tool, primarily to learn the language rust. The idea was to build replacement
for [password](https://github.com/tych0/password), which, while I use daily,
could use a few extra features.

While I could elaborate on `pw`'s features, I think it's best to just copy the
text from `pw`'s readme:

`pw` uses `pbkdf2` with `sha512` to stretch your password, with the supplied
entity as the salt. The result is encoded in base58, meaning that each symbol
in the password has ~5.86 of entropy. By default, pw generates passwords of
length 20, so there are ~117 bits of entropy per (default) password. By
comparison, ["correct horse battery staple"](https://xkcd.com/936/) is only 44.

#### Password Rotation

Changing passwords, memorably. `pw` offers several features for changing the
generated password for a given salt and user secret combination. For example,
some organizations require users to change their password every 90 days. This
is security theater, but nonetheless, users must cooperate. Using a standard
password generator, users could append a "2" and a "3" ("4"...) to their
password ad infinitum; the problem with this is that it makes some part of the
plaintext input known. `pw` uses a novel method of changing the number of
iterations for `pbkdf2` based on such inputs. `--otp` can be directly used to
change the number of iterations and thus the generated password. `--period` and
`--date` can be used together to work around organizations who e.g. require you
to change your password every 90 days. `--period` alone calculates the password
based on the current date, while `--date` allows you to pass an arbitrary date
for which to calculate password.

#### Adding Special Characters

By default the base58 encoding includes only alphanumeric characters. Some
organizations require special characters in their passwords. Users can add
arbitrary special characters by supplying an argument to `--special`. By
default, `--special` includes 25 typically allowed special characters.

#### Salt Recommendations

The salt is of particular importance to generated passwords. A typical
suggestion is to use the domain of the entity that the password is for, but the
problem is that an attacker who steals usbank.com's password database may just
generate a rainbow table for usbank.com. So, some personalized version of the
salt is recommended. For example, I might choose tycho.usbank.com. An
additional feature (discussed in TODO) would be a global offset for the
algorithm, so people could choose e.g. to not use the default offset of 0, but
something else for all of their passwords.

#### Usage

`pw` has support for storing a password in the OS native keyring, via
`--{get,set,delete}-keyring-password`, so that users don't have to type in
their password each invocation.

There is also X11 clipboard support on Linux via `xclip`, so users can pass
`--clipboard` to pw, and it will automatically copy the generated password to
the clipboard.

Finally, worth noting is that `pw` has support for a configuration file,
allowing for a few other features, which can be configured via
`--{get,set,edit,delete}-keyring-config`. For example, users can store OTP
offsets, special character sets, or even pre-shared key material (config key
`preshared`, a string) to use for generating particular passwords. Currently
this config file must be stored in the keyring, so it is not exposed to
unencrypted access. Of course, this is not stateless, and pw can function
entirely without this configuration, but it may be useful to some.
