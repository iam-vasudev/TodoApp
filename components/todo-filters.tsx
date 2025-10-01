"use client"

import { Button } from "@/components/ui/button"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import type { FilterType } from "@/app/page"

interface TodoFiltersProps {
  filter: FilterType
  categoryFilter: string
  onFilterChange: (filter: FilterType) => void
  onCategoryFilterChange: (category: string) => void
  onClearCompleted: () => void
  hasCompleted: boolean
}

export function TodoFilters({
  filter,
  categoryFilter,
  onFilterChange,
  onCategoryFilterChange,
  onClearCompleted,
  hasCompleted,
}: TodoFiltersProps) {
  return (
    <div className="flex flex-col gap-3 w-full">
      <div className="flex flex-wrap items-center gap-2">
        <Button size="sm" variant={filter === "all" ? "default" : "outline"} onClick={() => onFilterChange("all")}>
          All
        </Button>
        <Button
          size="sm"
          variant={filter === "active" ? "default" : "outline"}
          onClick={() => onFilterChange("active")}
        >
          Active
        </Button>
        <Button
          size="sm"
          variant={filter === "completed" ? "default" : "outline"}
          onClick={() => onFilterChange("completed")}
        >
          Completed
        </Button>
      </div>

      <div className="flex flex-col sm:flex-row items-start sm:items-center gap-2 w-full">
        <Select value={categoryFilter} onValueChange={onCategoryFilterChange}>
          <SelectTrigger className="w-full sm:w-40">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Categories</SelectItem>
            <SelectItem value="personal">Personal</SelectItem>
            <SelectItem value="work">Work</SelectItem>
            <SelectItem value="shopping">Shopping</SelectItem>
            <SelectItem value="other">Other</SelectItem>
          </SelectContent>
        </Select>

        {hasCompleted && (
          <Button
            size="sm"
            variant="outline"
            onClick={onClearCompleted}
            className="text-red-600 hover:text-red-700 dark:text-red-400 bg-transparent w-full sm:w-auto whitespace-nowrap"
          >
            Clear Completed
          </Button>
        )}
      </div>
    </div>
  )
}
