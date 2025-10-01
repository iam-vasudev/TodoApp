"use client"

import { useState, useEffect } from "react"
import { TodoForm } from "@/components/todo-form"
import { TodoList } from "@/components/todo-list"
import { TodoFilters } from "@/components/todo-filters"
import { ThemeToggle } from "@/components/theme-toggle"
import { Card } from "@/components/ui/card"

export interface Todo {
  id: string
  text: string
  completed: boolean
  createdAt: Date
  category: "personal" | "work" | "shopping" | "other"
  priority: "low" | "medium" | "high"
}

export type FilterType = "all" | "active" | "completed"

export default function TodoApp() {
  const [todos, setTodos] = useState<Todo[]>([])
  const [filter, setFilter] = useState<FilterType>("all")
  const [categoryFilter, setCategoryFilter] = useState<string>("all")

  // Load todos from localStorage on mount
  useEffect(() => {
    const savedTodos = localStorage.getItem("todos")
    if (savedTodos) {
      const parsedTodos = JSON.parse(savedTodos).map((todo: any) => ({
        ...todo,
        createdAt: new Date(todo.createdAt),
      }))
      setTodos(parsedTodos)
    }
  }, [])

  // Save todos to localStorage whenever todos change
  useEffect(() => {
    localStorage.setItem("todos", JSON.stringify(todos))
  }, [todos])

  const addTodo = (text: string, category: Todo["category"], priority: Todo["priority"]) => {
    const newTodo: Todo = {
      id: crypto.randomUUID(),
      text,
      completed: false,
      createdAt: new Date(),
      category,
      priority,
    }
    setTodos((prev) => [newTodo, ...prev])
  }

  const toggleTodo = (id: string) => {
    setTodos((prev) => prev.map((todo) => (todo.id === id ? { ...todo, completed: !todo.completed } : todo)))
  }

  const deleteTodo = (id: string) => {
    setTodos((prev) => prev.filter((todo) => todo.id !== id))
  }

  const editTodo = (id: string, newText: string) => {
    setTodos((prev) => prev.map((todo) => (todo.id === id ? { ...todo, text: newText } : todo)))
  }

  const clearCompleted = () => {
    setTodos((prev) => prev.filter((todo) => !todo.completed))
  }

  const filteredTodos = todos.filter((todo) => {
    const statusMatch =
      filter === "all" || (filter === "active" && !todo.completed) || (filter === "completed" && todo.completed)

    const categoryMatch = categoryFilter === "all" || todo.category === categoryFilter

    return statusMatch && categoryMatch
  })

  const stats = {
    total: todos.length,
    active: todos.filter((t) => !t.completed).length,
    completed: todos.filter((t) => t.completed).length,
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 dark:from-slate-900 dark:to-slate-800 p-4">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8 relative">
          <div className="absolute top-0 right-0">
            <ThemeToggle />
          </div>
          <h1 className="text-4xl font-bold text-slate-800 dark:text-slate-100 mb-2 text-balance">TODO APP</h1>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <Card className="p-4 text-center bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm border-slate-200 dark:border-slate-600">
            <div className="text-2xl font-bold text-blue-600 dark:text-blue-400">{stats.total}</div>
            <div className="text-sm text-slate-600 dark:text-slate-400">Total Tasks</div>
          </Card>
          <Card className="p-4 text-center bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm border-slate-200 dark:border-slate-600">
            <div className="text-2xl font-bold text-amber-600 dark:text-amber-400">{stats.active}</div>
            <div className="text-sm text-slate-600 dark:text-slate-400">Active</div>
          </Card>
          <Card className="p-4 text-center bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm border-slate-200 dark:border-slate-600">
            <div className="text-2xl font-bold text-green-600 dark:text-green-400">{stats.completed}</div>
            <div className="text-sm text-slate-600 dark:text-slate-400">Completed</div>
          </Card>
        </div>

        {/* Main Content */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Add Todo Form */}
          <div className="lg:col-span-1">
            <Card className="p-6 bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm border-slate-200 dark:border-slate-600">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-100">Add New Task</h2>
              <TodoForm onAddTodo={addTodo} />
            </Card>
          </div>

          {/* Todo List */}
          <div className="lg:col-span-2">
            <Card className="p-6 bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm border-slate-200 dark:border-slate-600">
              <div className="flex flex-col gap-4 mb-6">
                <h2 className="text-xl font-semibold text-slate-800 dark:text-slate-100">Your Tasks</h2>
                <TodoFilters
                  filter={filter}
                  categoryFilter={categoryFilter}
                  onFilterChange={setFilter}
                  onCategoryFilterChange={setCategoryFilter}
                  onClearCompleted={clearCompleted}
                  hasCompleted={stats.completed > 0}
                />
              </div>
              <TodoList todos={filteredTodos} onToggle={toggleTodo} onDelete={deleteTodo} onEdit={editTodo} />
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}
