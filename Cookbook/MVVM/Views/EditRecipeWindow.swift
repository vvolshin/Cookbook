////
////  EditRecipeWindow.swift
////  Cookbook
////
////  Created by Vitaly Volshin on 12/19/24.
////
//
//import SwiftUI
//import PhotosUI
//
//struct EditRecipeWindow: View {
//    let recipe: Recipe
//    let activeTab: TabType
//    @ObservedObject var recipeViewModel: ViewModel
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var recipeType: TabType
//    @State private var recipeName: String
//    @State private var recipeCategory: String
//    @State private var recipeInstructions: String
//    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var recipeImage: Data?
//    @State private var recipeIngredients: [String]
//    @State private var recipeMeasures: [String]
//    
//    @State private var showAlert = false
//    @State private var showTypePopover = false
//    @State private var showCategoryPopover = false
//    
//    var categories: [String] {
//        recipeType == .toEat
//        ? Array(recipeViewModel.mealCategories.keys)
//        : Array(recipeViewModel.drinkCategories.keys)
//    }
//    
//    init(recipe: Recipe, activeTab: TabType, recipeViewModel: ViewModel) {
//        self.recipe = recipe
//        self.activeTab = activeTab
//        self.recipeViewModel = recipeViewModel
//        
//        _recipeType = State(initialValue: activeTab)
//        _recipeName = State(initialValue: recipe.name ?? "")
//        _recipeCategory = State(initialValue: recipe.category ?? "")
//        _recipeInstructions = State(initialValue: recipe.instructions ?? "")
//        _recipeImage = State(initialValue: recipe.thumbnail)
//        _recipeIngredients = State(initialValue: Array(recipe.ingredients))
//        _recipeMeasures = State(initialValue: Array(recipe.measures))
//    }
//    
//    var body: some View {
//        VStack {
//            topBar()
//                .padding(.horizontal, 16)
//            mainContent()
//                .padding(.top, 8)
//                .padding(.horizontal, 16)
//                .background(Color.ownWhite)
//                .clipShape(.rect(cornerRadii: .init(topLeading: 25, topTrailing: 25)))
//        }
//        .background(Color.ownYellow)
//        .navigationBarBackButtonHidden(true)
//        .scrollIndicators(.hidden)
//        .ignoresSafeArea(.container, edges: .bottom)
//        .modifier(
//            ErrorAlertModifier(
//                showAlert: $showAlert,
//                errorTitle: "Empty recipe field",
//                errorMessage: "All fields must be filled."
//            ))
//    }
//    
//    private func topBar() -> some View {
//        HStack {
//            BackButton()
//            Spacer()
//            saveEditsButton()
//        }
//    }
//    
//    private func mainContent() -> some View {
//        ScrollView {
//            typeRow()
//                .frame(height: 44)
//                .padding(.top, 16)
//            Divider()
//            nameArea()
//                .frame(height: 44)
//            Divider()
//            categoryArea()
//                .frame(height: 44)
//            Divider()
//            imageArea()
//                .frame(height: 44)
//            Divider()
//            ingredientsArea()
//            Divider()
//            instructionsArea()
//            Spacer(minLength: 100)
//        }
//    }
//    
//    private func typeRow() -> some View {
//        ZStack(alignment: .leading) {
//            Button(action: {
//                showTypePopover.toggle()
//            }) {
//                Text("Type")
//                    .foregroundColor(.ownDarkOrange)
//                    .offset(y: -25)
//                    .scaleEffect(0.8, anchor: .leading)
//            }
//            .popover(isPresented: $showTypePopover, attachmentAnchor: .point(.bottom), arrowEdge: .top) {
//                VStack {
//                    Button("Meal") {
//                        recipeType = .toEat
//                        showTypePopover.toggle()
//                    }
//                    .foregroundColor(recipeType == .toEat ? .ownDarkOrange : .ownBlack.opacity(0.5))
//                    
//                    Divider()
//                    
//                    Button("Drink") {
//                        recipeType = .toDrink
//                        showTypePopover.toggle()
//                    }
//                    .foregroundColor(recipeType == .toDrink ? .ownDarkOrange : .ownBlack.opacity(0.5))
//                }
//                .padding()
//                .frame(width: 100, alignment: .leading)
//                .presentationCompactAdaptation(.popover)
//            }
//            
//            TextField("", text: Binding(
//                get: {
//                    recipeType == .toEat ? "Meal" : (recipeType == .toDrink ? "Drink" : "")
//                },
//                set: { newValue in
//                    if newValue == "Meal" {
//                        recipeType = .toEat
//                    } else if newValue == "Drink" {
//                        recipeType = .toDrink
//                    }
//                }
//            ))
//            .disabled(true)
//        }
//        .animation(.default, value: recipeType)
//    }
//    
//    private func nameArea() -> some View {
//        ZStack(alignment: .leading) {
//            Text ("Name")
//                .foregroundColor(recipeName.isEmpty ? .ownBlack.opacity(0.5) : .ownDarkOrange)
//                .offset(y: recipeName.isEmpty ? 0 : -25)
//                .scaleEffect(recipeName.isEmpty ? 1: 0.8, anchor: .leading)
//            TextField("", text: $recipeName)
//                .onChange(of: recipeName) {
//                    if recipeName.count > 30 {
//                        recipeName = String(recipeName.prefix(30))
//                    }
//                }
//        }
//        .animation(.default, value: recipeName)
//    }
//    
//    private func categoryArea() -> some View {
//        ZStack(alignment: .leading) {
//            Button(action: {
//                showCategoryPopover.toggle()
//            }) {
//                Text("Category")
//                    .foregroundColor(recipeCategory.isEmpty ? .ownBlack.opacity(0.5) : .ownDarkOrange)
//                    .offset(y: recipeCategory.isEmpty ? 0 : -25)
//                    .scaleEffect(recipeCategory.isEmpty ? 1: 0.8, anchor: .leading)
//            }
//            .popover(isPresented: $showCategoryPopover, attachmentAnchor: .point(.bottom), arrowEdge: .top) {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 12) {
//                        ForEach(categories, id: \.self) { option in
//                            Button(option) {
//                                recipeCategory = option
//                                showCategoryPopover.toggle()
//                            }
//                            .foregroundColor(option == recipeCategory ? .ownDarkOrange : .ownBlack.opacity(0.5))
//                            
//                            if option != categories.last {
//                                Divider()
//                            }
//                        }
//                    }
//                }
//                .scrollIndicators(.hidden)
//                .padding()
//                .frame(alignment: .leading)
//                .presentationCompactAdaptation(.popover)
//            }
//            
//            TextField("", text: $recipeCategory)
//                .disabled(true)
//        }
//        .animation(.default, value: recipeType)
//    }
//    
//    private func imageArea() -> some View {
//        HStack {
//            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
//                Text(recipeImage == nil ? "Choose Image" : "Image")
//                    .foregroundColor(recipeImage == nil ? .ownBlack.opacity(0.5) : Color.ownOrange)
//            }
//            .onChange(of: selectedItem) {
//                Task {
//                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self) {
//                        recipeImage = data
//                    }
//                }
//            }
//            
//            Spacer()
//            
//            RecipeImageView(imageData: recipeImage, width: 60, height: 44, cornerRadius: 8)
//        }
//    }
//    
//    private func ingredientsArea() -> some View {
//        VStack {
//            HStack {
//                Text("Ingredients & Measures")
//                    .foregroundColor(recipeIngredients.isEmpty ? .ownBlack.opacity(0.5) : .ownDarkOrange)
//                    .frame(height: 44)
//                
//                Spacer()
//            }
//            
//            ingredientRows()
//            addIngredientButton()
//        }
//    }
//    
//    private func ingredientRows() -> some View {
//        ForEach(0..<recipeIngredients.count, id: \.self) { index in
//            ingredientRow(index: index)
//        }
//    }
//    
//    private func ingredientRow(index: Int) -> some View {
//        HStack {
//            Group {
//                TextField("Ingredient", text: $recipeIngredients[index])
//                TextField("Measure", text: $recipeMeasures[index])
//            }
//            .padding(8)
//            .background(Color.gray.opacity(0.1))
//            
//            deleteIngredientButton(index: index)
//                .frame(width: 24, height: 24)
//        }
//    }
//    
//    private func addIngredientButton() -> some View {
//        Button(action: {
//            recipeIngredients.append("")
//            recipeMeasures.append("")
//        }) {
//            HStack {
//                Image(systemName: "plus")
//                Text("Add Ingredient")
//            }
//            .foregroundColor(Color.ownOrange)
//            .padding(.top, 8)
//        }
//    }
//    
//    private func deleteIngredientButton(index: Int) -> some View {
//        Button(action: {
//            recipeIngredients.remove(at: index)
//            recipeMeasures.remove(at: index)
//        }) {
//            Image(systemName: "trash")
//        }
//    }
//    
//    private func instructionsArea() -> some View {
//        VStack {
//            HStack {
//                Text("Instructions")
//                    .foregroundColor(recipeInstructions.isEmpty ? .ownBlack.opacity(0.5) : .ownDarkOrange)
//                    .frame(height: 44)
//                
//                Spacer()
//            }
//            TextEditor(text: $recipeInstructions)
//                .padding()
//                .border(Color.ownBlack.opacity(0.5), width: 0.5)
//                .frame(minHeight: 150)
//                .scrollIndicators(.hidden)
//        }
//        .frame(maxWidth: .infinity, alignment: .center)
//    }
//    
//    private func saveEditsButton() -> some View {
//        Button(action: {
//            if validateRecipe() {
//                saveChanges()
//            } else {
//                showAlert = true
//            }
//        }) {
//            Image("check")
//                .foregroundColor(Color.ownBlack)
//        }
//    }
//    
//    private func validateRecipe() -> Bool {
//        let validationChecks = [
//            !recipeName.isEmpty,
//            !recipeCategory.isEmpty,
//            recipeImage != nil,
//            validateIngredientsAndMeasures(),
//            !recipeInstructions.isEmpty
//        ]
//        
//        return validationChecks.allSatisfy { $0 }
//    }
//    
//    private func validateIngredientsAndMeasures() -> Bool {
//        for (ingredient, measure) in zip(recipeIngredients, recipeMeasures) {
//            let trimmedIngredient = ingredient.trimmingCharacters(in: .whitespaces)
//            let trimmedMeasure = measure.trimmingCharacters(in: .whitespaces)
//            
//            if !trimmedMeasure.isEmpty && trimmedIngredient.isEmpty {
//                return false
//            }
//            
//            if trimmedIngredient.isEmpty && trimmedMeasure.isEmpty {
//                continue
//            }
//        }
//        
//        return true
//    }
//    
//    private func saveChanges() {
//        let filteredIngredientsAndMeasures = zip(recipeIngredients, recipeMeasures)
//            .filter { !$0.0.trimmingCharacters(in: .whitespaces).isEmpty || !$0.1.trimmingCharacters(in: .whitespaces).isEmpty }
//        
//        let filteredIngredients = filteredIngredientsAndMeasures.map { $0.0 }
//        let filteredMeasures = filteredIngredientsAndMeasures.map { $0.1 }
//        
//        recipeViewModel.updateRecipe(
//            activeTab: activeTab,
//            recipe: recipe,
//            newName: recipeName,
//            newImage: recipeImage,
//            newInstructions: recipeInstructions,
//            newIngredients: filteredIngredients,
//            newMeasures: filteredMeasures
//        )
//        
//        dismiss()
//    }
//}
//
//#Preview {
//    let recipeID = "1"
//    let recipeName = "Pasta Carbonara"
//    let recipeThumbnail = Data()
//    let recipeCategory = "Italian"
//    let recipeInstructions = "Boil pasta. Fry bacon. Mix eggs and cheese. Combine everything."
//    let recipeIngredients = ["Pasta", "Bacon", "Eggs", "Cheese", "Black Pepper"]
//    let recipeMeasures = ["200g", "100g", "2", "50g", "to taste"]
//    
//    let carbonaraRecipe = Recipe(id: recipeID, name: recipeName, thumbnail: recipeThumbnail, category: recipeCategory, instructions: recipeInstructions, ingredients: recipeIngredients, measures: recipeMeasures)
//    
//    EditRecipeWindow(
//        recipe: carbonaraRecipe,
//        activeTab: .toEat,
//        recipeViewModel: ViewModel()
//    )
//}
