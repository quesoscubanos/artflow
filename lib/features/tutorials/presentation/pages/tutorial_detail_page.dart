import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/core/data/tutorial_data.dart';

// Tutorial data model
class Tutorial {
  final String id;
  final String title;
  final List<TutorialStep> steps;

  const Tutorial({
    required this.id,
    required this.title,
    required this.steps,
  });

  int get totalSteps => steps.length;
}

class TutorialStep {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

// Mock tutorial data
final Map<String, Tutorial> tutorialsData = {
  'perspective-drawing': Tutorial(
    id: 'perspective-drawing',
    title: 'Dibujo con Perspectiva',
    steps: [
      TutorialStep(
        id: 'step-1',
        title: 'Dibuja la Línea del Horizonte',
        description: 'Comienza dibujando una línea horizontal a través de tu papel. Esto representa el nivel de los ojos y será la base para tu dibujo en perspectiva.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-2',
        title: 'Agrega Puntos de Fuga',
        description: 'Marca dos puntos en la línea del horizonte, uno a cada lado. Estos serán tus puntos de fuga donde convergen todas las líneas paralelas.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-3',
        title: 'Dibuja Líneas de Perspectiva',
        description: 'Conecta los puntos de fuga para crear líneas diagonales que guiarán tu dibujo. Estas líneas muestran cómo los objetos parecen hacerse más pequeños a medida que se alejan.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-4',
        title: 'Agrega Formas Básicas',
        description: 'Usando las líneas de perspectiva como guías, dibuja formas básicas como cubos o cajas. Asegúrate de que los bordes se alineen con tus líneas de perspectiva.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-5',
        title: 'Refina el Dibujo',
        description: 'Agrega detalles y refina tus formas. Recuerda que los objetos más cercanos a ti deben aparecer más grandes y detallados.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-6',
        title: 'Agrega Sombras',
        description: 'Agrega sombras y luces para dar profundidad y dimensión a tu dibujo. Las fuentes de luz deben ser consistentes en todo el dibujo.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-7',
        title: 'Toques Finales',
        description: 'Revisa tu trabajo y agrega cualquier detalle final. Tu dibujo en perspectiva ahora debería mostrar profundidad y realismo adecuados.',
        imageUrl: 'images/perspective.png',
      ),
    ],
  ),
  'gallery-1': Tutorial(
    id: 'gallery-1',
    title: 'Técnicas Avanzadas de Sombras',
    steps: [
      TutorialStep(
        id: 'step-1',
        title: 'Entendiendo Fuentes de Luz',
        description: 'Identifica la fuente de luz principal y cómo afecta las sombras y luces en tu dibujo.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-2',
        title: 'Escala de Valores Básica',
        description: 'Crea una escala de valores desde blanco puro hasta negro puro para entender el rango tonal.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-3',
        title: 'Sombras Proyectadas',
        description: 'Aprende a dibujar sombras realistas proyectadas por objetos sobre otras superficies.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-4',
        title: 'Sombras de Forma',
        description: 'Domina las sombras que definen la forma tridimensional de los objetos.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-5',
        title: 'Luz Reflejada',
        description: 'Agrega luz reflejada sutil para hacer que tus sombras sean más realistas y sofisticadas.',
        imageUrl: 'images/perspective.png',
      ),
    ],
  ),
  'gallery-2': Tutorial(
    id: 'gallery-2',
    title: 'Fundamentos de Pintura Digital',
    steps: [
      TutorialStep(
        id: 'step-1',
        title: 'Configurando Tu Espacio de Trabajo',
        description: 'Configura tu software de pintura digital con pinceles y configuraciones apropiadas.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-2',
        title: 'Técnicas de Pinceles Digitales',
        description: 'Aprende diferentes tipos de pinceles y cómo usar la sensibilidad a la presión efectivamente.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-3',
        title: 'Gestión de Capas',
        description: 'Organiza tu trabajo con capas para un mejor control y edición no destructiva.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-4',
        title: 'Mezcla de Colores en Digital',
        description: 'Entiende cómo mezclar colores digitalmente y crear esquemas de color armoniosos.',
        imageUrl: 'images/perspective.png',
      ),
    ],
  ),
  'gallery-3': Tutorial(
    id: 'gallery-3',
    title: 'Composición y Equilibrio',
    steps: [
      TutorialStep(
        id: 'step-1',
        title: 'Regla de los Tercios',
        description: 'Divide tu lienzo en tercios y coloca elementos clave a lo largo de estas líneas.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-2',
        title: 'Puntos Focales',
        description: 'Crea un punto focal claro que atraiga primero la mirada del espectador.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-3',
        title: 'Jerarquía Visual',
        description: 'Organiza los elementos para guiar al espectador a través de tu composición de manera lógica.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-4',
        title: 'Equilibrio y Peso',
        description: 'Logra equilibrio visual mediante la colocación estratégica de elementos.',
        imageUrl: 'images/perspective.png',
      ),
    ],
  ),
  'gallery-4': Tutorial(
    id: 'gallery-4',
    title: 'Dominio del Acuarela',
    steps: [
      TutorialStep(
        id: 'step-1',
        title: 'Selección de Papel',
        description: 'Elige el papel de acuarela adecuado para tu técnica y efectos deseados.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-2',
        title: 'Técnica Húmedo sobre Húmedo',
        description: 'Domina la técnica húmedo sobre húmedo para efectos suaves y mezclados.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-3',
        title: 'Capas de Color',
        description: 'Construye profundidad mediante capas de lavados transparentes de acuarela.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-4',
        title: 'Trabajo de Detalles',
        description: 'Agrega detalles finos y texturas una vez que las capas base estén secas.',
        imageUrl: 'images/perspective.png',
      ),
      TutorialStep(
        id: 'step-5',
        title: 'Corrigiendo Errores',
        description: 'Aprende técnicas para corregir errores comunes de acuarela e imperfecciones.',
        imageUrl: 'images/perspective.png',
      ),
    ],
  ),
};

class TutorialDetailPage extends StatefulWidget {
  final String tutorialId;
  final int initialStep;
  final bool isAdmin;

  const TutorialDetailPage({
    super.key,
    required this.tutorialId,
    this.initialStep = 0,
    this.isAdmin = false,
  });

  @override
  State<TutorialDetailPage> createState() => _TutorialDetailPageState();
}

class _TutorialDetailPageState extends State<TutorialDetailPage> {
  late int currentStepIndex;
  late Tutorial tutorial;

  @override
  void initState() {
    super.initState();
    // In a real app, you'd fetch the tutorial by ID
    tutorial = allTutorialsData[widget.tutorialId] ?? allTutorialsData.values.first;
    currentStepIndex = widget.initialStep.clamp(0, tutorial.steps.length - 1);
  }

  TutorialStep get currentStep => tutorial.steps[currentStepIndex];
  double get progress => (currentStepIndex + 1) / tutorial.totalSteps;

  void _goToPrevious() {
    if (currentStepIndex > 0) {
      setState(() {
        currentStepIndex--;
      });
    }
  }

  void _goToNext() {
    if (currentStepIndex < tutorial.steps.length - 1) {
      setState(() {
        currentStepIndex++;
      });
    }
  }

  void _markAsCompleted() {
    // In a real app, you'd save progress to a database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Tutorial marcado como completado!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: widget.isAdmin ? () => Navigator.of(context).pop() : () => context.go('/tutorials'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tutorial title
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                tutorial.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),

            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paso ${currentStepIndex + 1} de ${tutorial.totalSteps}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.primaryPink,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  ),
                ],
              ),
            ),

            // Tutorial image
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                minHeight: 200,
              ),
              child: Image.asset(
                currentStep.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.inputFillColor,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: AppTheme.textLight,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Step content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step title
                  Text(
                    currentStep.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Step description
                  Text(
                    currentStep.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation buttons
                  Row(
                    children: [
                      // Previous button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: currentStepIndex > 0 ? _goToPrevious : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppTheme.primaryBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Anterior',
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Next button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: currentStepIndex < tutorial.steps.length - 1 ? _goToNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            currentStepIndex < tutorial.steps.length - 1 ? 'Siguiente' : 'Completar',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Mark as completed button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _markAsCompleted,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppTheme.primaryPink),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Marcar como Completado',
                        style: TextStyle(
                          color: AppTheme.primaryPink,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}