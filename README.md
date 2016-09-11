# Storer

Simple example of using persistent_storage in a worker under supervision.

See: https://github.com/cellulose/persistent_storage

Start it with `iex -S mix` and watch the debug output.

When Storer.Worker is started, it initializes the storage location (/tmp/storer) and then sends itself a message. A second later, when it receives the message, it writes a value. It then sends itself another message.  When that message is received, it retrieves the value from storage.
