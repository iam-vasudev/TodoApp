"use client"

import { TodoItem } from "@/components/todo-item"
import type { Todo } from "@/app/page"

interface TodoListProps {
  todos: Todo[]
  onToggle: (id: string) => void
  onDelete: (id: string) => void
  onEdit: (id: string, newText: string) => void
}

export function TodoList({ todos, onToggle, onDelete, onEdit }: TodoListProps) {
  if (todos.length === 0) {
    return (
      <div className="text-center py-12">
        <div className="text-slate-400 dark:text-slate-500 text-lg">No tasks found</div>
        <div className="text-slate-500 dark:text-slate-600 text-sm mt-2">Add a new task to get started</div>
      </div>
    )
  }

  return (
    <div className="space-y-2">
      {todos.map((todo) => (
        <TodoItem key={todo.id} todo={todo} onToggle={onToggle} onDelete={onDelete} onEdit={onEdit} />
      ))}
    </div>
  )
}
