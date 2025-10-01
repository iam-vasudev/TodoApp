"use client"

import { useTheme } from "./theme-provider"
import { Button } from "@/components/ui/button"

export function ThemeToggle() {
  const { theme, setTheme } = useTheme()

  const toggleTheme = () => {
    if (theme === "light") {
      setTheme("dark")
    } else {
      setTheme("light")
    }
  }

  const getThemeIcon = () => {
    return theme === "light" ? "🌙" : "☀️"
  }

  const getThemeLabel = () => {
    return theme === "light" ? "Dark" : "Light"
  }

  return (
    <Button
      variant="outline"
      size="sm"
      onClick={toggleTheme}
      className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm border-slate-200 dark:border-slate-600 hover:bg-white dark:hover:bg-slate-800"
    >
      <span className="mr-2">{getThemeIcon()}</span>
      {getThemeLabel()}
    </Button>
  )
}
