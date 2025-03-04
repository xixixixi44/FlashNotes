import SwiftUI

struct ContentView: View {
    @StateObject private var noteStore = NoteStore()
    @State private var isAddingNote = false
    @State private var activeCardIndex = 0
    @State private var cardSequence: [Note] = []
    @State private var isPlaying = false
    @State private var carouselTimer: Timer? = nil
    
    private let carouselSpeed: TimeInterval = 3.0 // Card carousel speed (seconds)
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack {
                toolbar
                
                if noteStore.notes.isEmpty {
                    emptyStateView
                } else {
                    cardCarouselView
                }
            }
            .padding()
        }
        .sheet(isPresented: $isAddingNote) {
            AddNoteView { newNote in
                noteStore.addNote(newNote)
                refreshCardSequence()
            }
        }
        .onAppear {
            refreshCardSequence()
        }
    }
    
    // Background gradient
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(.systemBackground),
                Color(.systemBackground).opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    // Toolbar
    private var toolbar: some View {
        HStack {
            Button(action: {
                isAddingNote = true
            }) {
                Label(L10n.newNote, systemImage: "plus.circle")
            }
            .buttonStyle(.plain)
            .padding(8)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(8)
            
            Spacer()
            
            // Carousel controls
            HStack(spacing: 12) {
                Button(action: {
                    togglePlayback()
                }) {
                    Label("", systemImage: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    refreshCardSequence()
                }) {
                    Label("", systemImage: "arrow.clockwise")
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .disabled(noteStore.notes.isEmpty)
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
    
    // Empty state view
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image("LightningIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
                .foregroundColor(.secondary)
            
            Text(L10n.noNotes)
                .font(.title2)
                .foregroundColor(.secondary)
            
            Button(action: {
                isAddingNote = true
            }) {
                Text(L10n.addFirstNote)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Card carousel view
    private var cardCarouselView: some View {
        VStack {
            if !cardSequence.isEmpty {
                NoteCardView(note: cardSequence[safe: activeCardIndex] ?? cardSequence[0])
                    .frame(maxWidth: 500, maxHeight: 300)
                    .transition(.opacity.combined(with: .scale))
                    .id(activeCardIndex) // Ensure view is recreated when switching
            }
            
            // Card navigation indicators
            if cardSequence.count > 1 {
                HStack(spacing: 8) {
                    ForEach(0..<cardSequence.count, id: \.self) { index in
                        Circle()
                            .fill(index == activeCardIndex ? Color.accentColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top)
            }
        }
        .padding()
    }
    
    // Randomize card sequence and reset carousel
    private func refreshCardSequence() {
        guard !noteStore.notes.isEmpty else { return }
        
        cardSequence = noteStore.notes.shuffled()
        activeCardIndex = 0
        
        // If currently playing, reset the timer
        if isPlaying {
            resetCarouselTimer()
        }
    }
    
    // Toggle playback state
    private func togglePlayback() {
        isPlaying.toggle()
        
        if isPlaying {
            resetCarouselTimer()
        } else {
            carouselTimer?.invalidate()
            carouselTimer = nil
        }
    }
    
    // Reset carousel timer
    private func resetCarouselTimer() {
        carouselTimer?.invalidate()
        
        carouselTimer = Timer.scheduledTimer(withTimeInterval: carouselSpeed, repeats: true) { _ in
            withAnimation(.easeInOut) {
                // Move to next card, loop back to start if at the end
                activeCardIndex = (activeCardIndex + 1) % cardSequence.count
            }
        }
    }
}

// Safe array index accessor extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
