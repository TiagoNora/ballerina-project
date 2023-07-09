import tkinter as tk
from tkinter import ttk
from tkinter import messagebox

def add_row():
    row = text_field.get()

    if row.strip() == "":
        messagebox.showwarning("Empty Field", "The text field is empty. Insert a row before adding.")
        return

    current_table.insert('', tk.END, values=(row,))
    text_field.delete(0, tk.END)
    update_file()

def update_row():
    selected_item = current_table.focus()
    if not selected_item:
        messagebox.showwarning("No Row Selected", "Select a row in the table to update.")
        return

    new_row = text_field.get()

    if new_row.strip() == "":
        messagebox.showwarning("Empty Field", "The text field is empty. Insert a row before updating.")
        return

    current_table.item(selected_item, values=(new_row,))
    update_file()

def delete_row():
    selected_item = current_table.focus()
    if not selected_item:
        messagebox.showwarning("No Row Selected", "Select a row in the table to delete.")
        return

    confirmation = messagebox.askyesno("Deletion Confirmation", "Are you sure you want to delete the selected row?")
    if confirmation:
        current_table.delete(selected_item)
        update_file()

def update_file():
    with open('./services/review/words/file.txt', 'w') as file:
        for item in current_table.get_children():
            row = current_table.item(item)['values'][0]
            file.write(row + '\n')

window = tk.Tk()
window.title("Writing Application")

width = 500
height = 400
window.geometry(f"{width}x{height}")

text_field = tk.Entry(window)
text_field.pack()

add_button = tk.Button(window, text="Add Row", command=add_row)
add_button.pack()

table_frame = tk.Frame(window)
table_frame.pack()

current_table = ttk.Treeview(table_frame, columns=('Row',), show='headings')
current_table.column('Row', width=400)
current_table.heading('Row', text='Row')
current_table.pack(side=tk.LEFT, fill=tk.BOTH)

vertical_scrollbar = tk.Scrollbar(table_frame, orient=tk.VERTICAL, command=current_table.yview)
vertical_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

current_table.configure(yscrollcommand=vertical_scrollbar.set)

with open('./services/review/words/file.txt', 'r') as file:
    rows = file.readlines()

for row in rows:
    row = row.strip()
    current_table.insert('', tk.END, values=(row,))

window.mainloop()
