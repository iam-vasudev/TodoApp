"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Checkbox } from "@/components/ui/checkbox"
import { Badge } from "@/components/ui/badge"
import { cn } from "@/lib/utils"
import type { Todo } from "@/app/page"

interface TodoItemProps {
  todo: Todo
  onToggle: (id: string) => void
  onDelete: (id: string) => void
  onEdit: (id: string, newText: string) => void
}

export function TodoItem({ todo, onToggle, onDelete, onEdit }: TodoItemProps) {
  const [isEditing, setIsEditing] = useState(false)
  const [editText, setEditText] = useState(todo.text)

  const handleEdit = () => {
    if (editText.trim() && editText !== todo.text) {
      onEdit(todo.id, editText.trim())
    }
    setIsEditing(false)
    setEditText(todo.text)
  }

  const handleCancel = () => {
    setIsEditing(false)
    setEditText(todo.text)
  }

  const getCategoryColor = (category: Todo["category"]) => {
    switch (category) {
      case "work":
        return "bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200"
      case "personal":
        return "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200"
      case "shopping":
        return "bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-200"
      default:
        return "bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200"
    }
  }

  const getPriorityColor = (priority: Todo["priority"]) => {
    switch (priority) {
      case "high":
        return "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
      case "medium":
        return "bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200"
      case "low":
        return "bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200"
    }
  }

  return (
    <div
      className={cn(
        "flex items-center gap-3 p-4 rounded-lg border transition-all duration-200",
        "bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-600 hover:shadow-md hover:border-slate-300 dark:hover:border-slate-500",
        todo.completed && "opacity-60",
      )}
    >
      <Checkbox checked={todo.completed} onCheckedChange={() => onToggle(todo.id)} className="flex-shrink-0" />

      <div className="flex-1 min-w-0">
        {isEditing ? (
          <div className="flex items-center gap-2">
            <Input
              value={editText}
              onChange={(e) => setEditText(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") handleEdit()
                if (e.key === "Escape") handleCancel()
              }}
              className="flex-1"
              autoFocus
            />
            <Button size="sm" onClick={handleEdit} variant="ghost">
              <span className="w-4 h-4 flex items-center justify-center">✓</span>
            </Button>
            <Button size="sm" onClick={handleCancel} variant="ghost">
              <span className="w-4 h-4 flex items-center justify-center">×</span>
            </Button>
          </div>
        ) : (
          <div className="space-y-2">
            <div
              className={cn("text-sm font-medium", todo.completed && "line-through text-slate-500 dark:text-slate-400")}
            >
              {todo.text}
            </div>
            <div className="flex items-center gap-2">
              <Badge variant="secondary" className={getCategoryColor(todo.category)}>
                {todo.category}
              </Badge>
              <Badge variant="secondary" className={getPriorityColor(todo.priority)}>
                {todo.priority}
              </Badge>
              <span className="text-xs text-slate-500 dark:text-slate-400">{todo.createdAt.toLocaleDateString()}</span>
            </div>
          </div>
        )}
      </div>

      {!isEditing && (
        <div className="flex items-center gap-1 flex-shrink-0">
          <Button size="sm" variant="ghost" onClick={() => setIsEditing(true)} disabled={todo.completed}>
            <span className="w-4 h-4 flex items-center justify-center">✎</span>
          </Button>
          <Button
            size="sm"
            variant="ghost"
            onClick={() => onDelete(todo.id)}
            className="text-red-600 hover:text-red-700 dark:text-red-400"
          >
            <span className="w-4 h-4 flex items-center justify-center">🗑</span>
          </Button>
        </div>
      )}
    </div>
  )
}
