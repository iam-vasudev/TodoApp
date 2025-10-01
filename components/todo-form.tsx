"use client"

import type React from "react"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import type { Todo } from "@/app/page"

interface TodoFormProps {
  onAddTodo: (text: string, category: Todo["category"], priority: Todo["priority"]) => void
}

export function TodoForm({ onAddTodo }: TodoFormProps) {
  const [text, setText] = useState("")
  const [category, setCategory] = useState<Todo["category"]>("personal")
  const [priority, setPriority] = useState<Todo["priority"]>("medium")

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (text.trim()) {
      onAddTodo(text.trim(), category, priority)
      setText("")
      setCategory("personal")
      setPriority("medium")
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <Input
          type="text"
          placeholder="What needs to be done?"
          value={text}
          onChange={(e) => setText(e.target.value)}
          className="w-full"
        />
      </div>

      <div className="grid grid-cols-2 gap-3">
        <div>
          <Select value={category} onValueChange={(value: Todo["category"]) => setCategory(value)}>
            <SelectTrigger>
              <SelectValue placeholder="Category" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="personal">Personal</SelectItem>
              <SelectItem value="work">Work</SelectItem>
              <SelectItem value="shopping">Shopping</SelectItem>
              <SelectItem value="other">Other</SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div>
          <Select value={priority} onValueChange={(value: Todo["priority"]) => setPriority(value)}>
            <SelectTrigger>
              <SelectValue placeholder="Priority" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="low">Low</SelectItem>
              <SelectItem value="medium">Medium</SelectItem>
              <SelectItem value="high">High</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>

      <Button type="submit" className="w-full" disabled={!text.trim()}>
        <span className="mr-2">+</span>
        Add Task
      </Button>
    </form>
  )
}
