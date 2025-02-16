//
//  ContentView.swift
//  Lifestylist
//
//  Created by Jake Sanghavi on 2/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var habits: [Habit] = []
    @State private var showAddHabitModal = false
    @State private var showTrackHabitModal = false
    @State private var selectedHabit: Habit?
    
    var body: some View {
        NavigationView {
            HStack {
                SidebarView(habits: $habits, selectedDate: $selectedDate, showTrackHabitModal: $showTrackHabitModal, selectedHabit: $selectedHabit)
                Divider()
                MainView(selectedHabit: $selectedHabit)
            }
            .sheet(isPresented: $showAddHabitModal) {
                AddHabitView(habits: $habits)
            }
            .sheet(isPresented: $showTrackHabitModal) {
                if let selectedHabit = selectedHabit {
                    TrackHabitView(habit: selectedHabit, selectedDate: selectedDate)
                }
            }
        }
    }
}

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var type: HabitType
    var records: [Date: HabitRecord]
}

enum HabitType: String, CaseIterable {
    case yesNo = "Yes/No"
    case amount = "Amount"
    case time = "Time"
}

struct HabitRecord {
    var value: String
}

struct SidebarView: View {
    @Binding var habits: [Habit]
    @Binding var selectedDate: Date
    @Binding var showTrackHabitModal: Bool
    @Binding var selectedHabit: Habit?
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .padding()
            
            List {
                ForEach(habits) { habit in
                    Button(action: {
                        selectedHabit = habit
                        showTrackHabitModal = true
                    }) {
                        Text(habit.name)
                    }
                }
            }
            
            Button(action: {
                showTrackHabitModal = true
            }) {
                Text("+").font(.largeTitle)
            }
            .padding()
        }
    }
}

struct MainView: View {
    @Binding var selectedHabit: Habit?
    
    var body: some View {
        VStack {
            if let habit = selectedHabit {
                Text("Habit Details for \(habit.name)")
                // Placeholder for habit graph implementation
            } else {
                Text("Select a habit to view its progress")
            }
        }
    }
}

struct AddHabitView: View {
    @Binding var habits: [Habit]
    @State private var habitName = ""
    @State private var habitType: HabitType = .yesNo
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Habit Name", text: $habitName)
                .padding()
            Picker("Type", selection: $habitType) {
                ForEach(HabitType.allCases, id: \..self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Add Habit") {
                let newHabit = Habit(name: habitName, type: habitType, records: [:])
                habits.append(newHabit)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}

struct TrackHabitView: View {
    let habit: Habit
    let selectedDate: Date
    @State private var value: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Track \(habit.name) for \(selectedDate, formatter: dateFormatter)")
            TextField("Enter value", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save") {
                // Save habit record logic
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

//struct Meal: Identifiable {
//    let id = UUID()
//    let name: String
//    let calories: Int
//    let protein: Int
//}
//
//struct Day: Identifiable {
//    let id = UUID()
//    let date: Date
//    var meals: [Meal]
//}
//
//class MealTrackerViewModel: ObservableObject {
//    @Published var days: [Day] = []
//    @Published var selectedDate = Date()
//    
//    init() {
//        loadDays()
//    }
//    
//    func loadDays() {
//        let today = Calendar.current.startOfDay(for: Date())
//        days = [Day(date: today, meals: [])]
//    }
//    
//    func addMeal(to date: Date, meal: Meal) {
//        if let index = days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
//            var updatedDay = days[index]
//            updatedDay.meals.append(meal)
//            days[index] = updatedDay  // Ensure SwiftUI recognizes the change
//        } else {
//            days.append(Day(date: date, meals: [meal]))
//        }
//    }
//    
//    func totalCalories(for date: Date) -> Int {
//        return days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?.meals.reduce(0) { $0 + $1.calories } ?? 0
//    }
//    
//    func totalProtein(for date: Date) -> Int {
//        return days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?.meals.reduce(0) { $0 + $1.protein } ?? 0
//    }
//    
//    var mealsForSelectedDate: [Meal] {
//        days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) })?.meals ?? []
//    }
//}
//
//struct ContentView: View {
//    @StateObject private var viewModel = MealTrackerViewModel()
//    @State private var showAddMeal = false
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
//                    .datePickerStyle(.graphical)
//                    .padding()
//                
//                List {
//                    Section(header: Text("Meals")) {
//                        ForEach(viewModel.mealsForSelectedDate) { meal in
//                            HStack {
//                                Text(meal.name)
//                                Spacer()
//                                Text("\(meal.calories) kcal, \(meal.protein)g protein")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                }
//                
//                HStack {
//                    Text("Calories: \(viewModel.totalCalories(for: viewModel.selectedDate))")
//                    Spacer()
//                    Text("Protein: \(viewModel.totalProtein(for: viewModel.selectedDate))g")
//                }
//                .padding()
//                
//                Button("Add Meal") {
//                    showAddMeal = true
//                }
//                .padding()
//                .sheet(isPresented: $showAddMeal) {
//                    AddMealView(viewModel: viewModel, selectedDate: viewModel.selectedDate)
//                }
//            }
//            .navigationTitle("Meal Tracker")
//        }
//    }
//}
//
//struct AddMealView: View {
//    @ObservedObject var viewModel: MealTrackerViewModel
//    var selectedDate: Date
//
//    @Environment(\.dismiss) var dismiss
//
//    @State private var mealName: String = ""
//    @State private var calories: String = ""
//    @State private var protein: String = ""
//
//    var body: some View {
//        NavigationView {
//            Form {
//                TextField("Meal Name", text: $mealName)
//                #if os(iOS)
//                TextField("Calories", text: $calories)
//                    .keyboardType(.numberPad)
//                TextField("Protein (g)", text: $protein)
//                    .keyboardType(.numberPad)
//                #else
//                TextField("Calories", text: $calories)
//                TextField("Protein (g)", text: $protein)
//                #endif
//
//                Button("Add Meal") {
//                    if let cal = Int(calories), let prot = Int(protein) {
//                        let newMeal = Meal(name: mealName, calories: cal, protein: prot)
//                        viewModel.addMeal(to: selectedDate, meal: newMeal)
//                        dismiss()
//                    }
//                }
//                .disabled(mealName.isEmpty || calories.isEmpty || protein.isEmpty)
//            }
//            .frame(minWidth: 300, minHeight: 300)  // 👈 Ensures form has enough space
//            .scrollContentBackground(.hidden)  // 👈 Fix for macOS background issues
//            .navigationTitle("Add Meal")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") { dismiss() }
//                }
//            }
//        }
//        .frame(minWidth: 350, minHeight: 400)  // 👈 Ensures the whole view expands
//    }
//}
//
//struct MealListView: View {
//    let meals: [Meal]
//    
//    var body: some View {
//        List(meals) { meal in
//            HStack {
//                Text(meal.name)
//                Spacer()
//                Text("\(meal.calories) kcal")
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
