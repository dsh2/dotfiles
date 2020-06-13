from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import HasFocus, HasSelection, ViInsertMode, EmacsInsertMode

ip = get_ipython()
insert_mode = ViInsertMode() | EmacsInsertMode()


def insert_unexpected(event):
    buf = event.current_buffer
    buf.insert_text('The Spanish Inquisition')


# # Register the shortcut if IPython is using prompt_toolkit
# if getattr(ip, 'pt_app', None):
#     registry = ip.pt_app.key_bindings
#     registry.add_binding(Keys.ControlN,
#                          filter=(HasFocus(DEFAULT_BUFFER)
#                                  & ~HasSelection()
#                                  & insert_mode))(insert_unexpected)
